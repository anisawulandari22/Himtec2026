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

# 3. Inject Custom High-Quality AGL App Launcher Icons & Adaptive Icons
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
        src_fg = os.path.join(src_dir, "ic_launcher_foreground.png")

        if os.path.exists(src_icon):
            shutil.copy2(src_icon, os.path.join(dst_dir, "ic_launcher.png"))
            print(f"Injected custom AGL icon into {dst_dir}/ic_launcher.png")
        if os.path.exists(src_round):
            shutil.copy2(src_round, os.path.join(dst_dir, "ic_launcher_round.png"))
            print(f"Injected custom AGL round icon into {dst_dir}/ic_launcher_round.png")
        if os.path.exists(src_fg):
            shutil.copy2(src_fg, os.path.join(dst_dir, "ic_launcher_foreground.png"))
            print(f"Injected custom AGL foreground into {dst_dir}/ic_launcher_foreground.png")

    # Setup Android Adaptive Icon XML (API 26+)
    anydpi_dir = os.path.join(res_dir, "mipmap-anydpi-v26")
    os.makedirs(anydpi_dir, exist_ok=True)
    adaptive_xml = """<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
"""
    with open(os.path.join(anydpi_dir, "ic_launcher.xml"), "w", encoding="utf-8") as f:
        f.write(adaptive_xml)
    with open(os.path.join(anydpi_dir, "ic_launcher_round.xml"), "w", encoding="utf-8") as f:
        f.write(adaptive_xml)
    print("Configured adaptive icons in mipmap-anydpi-v26")

    # Setup Background Drawable
    drawable_dir = os.path.join(res_dir, "drawable")
    os.makedirs(drawable_dir, exist_ok=True)
    bg_drawable = """<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#0B3828"
        android:pathData="M0,0h108v108h-108z"/>
</vector>
"""
    with open(os.path.join(drawable_dir, "ic_launcher_background.xml"), "w", encoding="utf-8") as f:
        f.write(bg_drawable)
    print("Created drawable/ic_launcher_background.xml")

    # Setup Colors
    values_dir = os.path.join(res_dir, "values")
    os.makedirs(values_dir, exist_ok=True)
    colors_path = os.path.join(values_dir, "colors.xml")
    if os.path.exists(colors_path):
        with open(colors_path, "r", encoding="utf-8") as f:
            c_text = f.read()
        if "ic_launcher_background" not in c_text:
            c_text = c_text.replace("</resources>", '    <color name="ic_launcher_background">#0B3828</color>\n</resources>')
            with open(colors_path, "w", encoding="utf-8") as f:
                f.write(c_text)
    else:
        with open(colors_path, "w", encoding="utf-8") as f:
            f.write("""<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#0B3828</color>
</resources>
""")
    print("Configured colors.xml with brand background color")
else:
    print(f"Icon source or destination not found: {assets_icon_dir} -> {res_dir}")
