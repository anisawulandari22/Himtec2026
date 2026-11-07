import os
import xml.etree.ElementTree as ET

manifest_path = "android/app/src/main/AndroidManifest.xml"
if os.path.exists(manifest_path):
    with open(manifest_path, "r", encoding="utf-8") as f:
        content = f.read()

    permissions = """
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
"""
    if "android.permission.CAMERA" not in content and "<application" in content:
        new_content = content.replace("<application", permissions + "\n    <application", 1)
        # Verify valid XML
        try:
            ET.fromstring(new_content)
            with open(manifest_path, "w", encoding="utf-8") as f:
                f.write(new_content)
            print("Successfully injected permissions and verified AndroidManifest.xml is valid XML.")
        except Exception as e:
            print(f"Error validating XML: {e}, falling back to original content.")
    else:
        print("Permissions already present or <application tag not found.")
else:
    print(f"Manifest not found at {manifest_path}")
