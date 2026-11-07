import os
import re
import shutil
import xml.etree.ElementTree as ET

# 1. Update AndroidManifest.xml (Permissions & App Label "AGL")
manifest_path = "android/app/src/main/AndroidManifest.xml"
if os.path.exists(manifest_path):
    with open(manifest_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Change android:label to "AGL" (instead of agl_app)
    content = re.sub(r'android:label="[^"]*"', 'android:label="AGL"', content)

    permissions = """
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28" />
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
"""
    if "android.permission.CAMERA" not in content and "<application" in content:
        content = content.replace("<application", permissions + "\n    <application", 1)

    # Verify valid XML
    try:
        ET.fromstring(content)
        with open(manifest_path, "w", encoding="utf-8") as f:
            f.write(content)
        print("Successfully updated AndroidManifest.xml: Injected permissions and set android:label=\"AGL\".")
    except Exception as e:
        print(f"Error validating XML: {e}")
else:
    print(f"Manifest not found at {manifest_path}")

# 2. Update strings.xml if present
strings_path = "android/app/src/main/res/values/strings.xml"
if os.path.exists(strings_path):
    with open(strings_path, "r", encoding="utf-8") as f:
        s_content = f.read()
    s_content = re.sub(r'<string name="app_name">[^<]*</string>', '<string name="app_name">AGL</string>', s_content)
    with open(strings_path, "w", encoding="utf-8") as f:
        f.write(s_content)
    print("Updated strings.xml with app_name=\"AGL\"")

# 3. Inject Custom High-Quality AGL App Launcher Icons
assets_icon_dir = "assets/icon"
res_dir = "android/app/src/main/res"
densities = ["mipmap-mdpi", "mipmap-hdpi", "mipmap-xhdpi", "mipmap-xxhdpi", "mipmap-xxxhdpi"]

if os.path.exists(assets_icon_dir) and os.path.exists(res_dir):
    for d in densities:
        src_dir = os.path.join(assets_icon_dir, d)
        dst_dir = os.path.join(res_dir, d)
        os.makedirs(dst_dir, exist_ok=True)
        src_icon = os.path.join(src_dir, "ic_launcher.png")
        src_round = os.path.join(src_dir, "ic_launcher_round.png")

        if os.path.exists(src_icon):
            shutil.copy2(src_icon, os.path.join(dst_dir, "ic_launcher.png"))
            print(f"Injected custom AGL icon into {dst_dir}/ic_launcher.png")
        if os.path.exists(src_round):
            shutil.copy2(src_round, os.path.join(dst_dir, "ic_launcher_round.png"))
            print(f"Injected custom AGL round icon into {dst_dir}/ic_launcher_round.png")
else:
    print(f"Icon source or destination not found: {assets_icon_dir} -> {res_dir}")
