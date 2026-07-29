#!/usr/bin/env python3
"""Add Swift files under AILifeOS to Xcode project.pbxproj"""
import os
import re
import uuid

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PBXPROJ = os.path.join(PROJECT_ROOT, "swift-ui-base.xcodeproj", "project.pbxproj")
SWIFT_BASE = os.path.join(PROJECT_ROOT, "swift-ui-base", "AILifeOS")

def gen_id():
    return uuid.uuid4().hex[:24].upper()

def find_swift_files():
    files = []
    for root, _, filenames in os.walk(SWIFT_BASE):
        for f in sorted(filenames):
            if f.endswith(".swift"):
                rel = os.path.relpath(os.path.join(root, f), os.path.join(PROJECT_ROOT, "swift-ui-base"))
                files.append(rel.replace("\\", "/"))
    return files

def main():
    with open(PBXPROJ, "r") as f:
        content = f.read()

    swift_files = find_swift_files()
    added = 0

    for rel_path in swift_files:
        if rel_path in content:
            continue
        file_ref_id = gen_id()
        build_file_id = gen_id()
        filename = os.path.basename(rel_path)
        dir_path = os.path.dirname(rel_path)

        build_entry = f"\t\t{build_file_id} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {filename} */; }};\n"
        file_ref_entry = f"\t\t{file_ref_id} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {filename}; sourceTree = \"<group>\"; }};\n"

        content = content.replace(
            "/* End PBXBuildFile section */",
            build_entry + "/* End PBXBuildFile section */"
        )
        content = content.replace(
            "/* End PBXFileReference section */",
            file_ref_entry + "/* End PBXFileReference section */"
        )

        # Add to Sources build phase
        content = content.replace(
            "07A64A002417E137003C6753 /* HomeView.swift in Sources */,",
            f"07A64A002417E137003C6753 /* HomeView.swift in Sources */,\n\t\t\t\t{build_file_id} /* {filename} in Sources */,"
        )

        added += 1
        print(f"Added: {rel_path}")

    # Add AILifeOS group structure to swift-ui-base group
    if "AILifeOS" not in content:
        ailifeos_group_id = gen_id()
        
        # Build nested groups for subdirs
        subdirs = {}
        for rel_path in swift_files:
            parts = rel_path.split("/")
            # parts: AILifeOS/Theme/AppTheme.swift
            subdir = parts[1] if len(parts) > 2 else "Screens"
            subdirs.setdefault(subdir, []).append(os.path.basename(rel_path))

        subgroup_ids = {}
        subgroup_blocks = ""
        children_lines = []
        
        for subdir in sorted(subdirs.keys()):
            sg_id = gen_id()
            subgroup_ids[subdir] = sg_id
            file_refs = []
            for fname in sorted(subdirs[subdir]):
                # find file ref id from content
                m = re.search(r'(\w{24}) /\* ' + re.escape(fname) + r' \*/ = \{isa = PBXFileReference', content)
                if m:
                    file_refs.append(f"\t\t\t\t{m.group(1)} /* {fname} */,")
            children_str = "\n".join(file_refs)
            subgroup_blocks += f"\t\t{sg_id} /* {subdir} */ = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n{children_str}\n\t\t\t);\n\t\t\tpath = {subdir};\n\t\t\tsourceTree = \"<group>\";\n\t\t}};\n"
            children_lines.append(f"\t\t\t\t{sg_id} /* {subdir} */,")

        ailifeos_block = f"\t\t{ailifeos_group_id} /* AILifeOS */ = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n" + "\n".join(children_lines) + "\n\t\t\t);\n\t\t\tpath = AILifeOS;\n\t\t\tsourceTree = \"<group>\";\n\t\t}};\n"
        
        content = content.replace(
            "/* End PBXGroup section */",
            subgroup_blocks + ailifeos_block + "/* End PBXGroup section */"
        )
        
        content = content.replace(
            "07442D0D241C169F00A235E7 /* Navigation */,",
            f"AI{ailifeos_group_id[:2]}AILIFEOS00000000001 /* AILifeOS */,\n\t\t\t\t07442D0D241C169F00A235E7 /* Navigation */,"
        )
        # Fix the placeholder - use actual id
        content = content.replace(
            f"AI{ailifeos_group_id[:2]}AILIFEOS00000000001 /* AILifeOS */",
            f"{ailifeos_group_id} /* AILifeOS */"
        )

    with open(PBXPROJ, "w") as f:
        f.write(content)

    print(f"Done. Added {added} files.")

if __name__ == "__main__":
    main()
