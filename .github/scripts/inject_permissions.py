import os

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
    if "android.permission.CAMERA" not in content:
        content = content.replace("<manifest", "<manifest" + permissions, 1)
        with open(manifest_path, "w", encoding="utf-8") as f:
            f.write(content)
        print("Camera and Internet permissions successfully injected into AndroidManifest.xml")
    else:
        print("Permissions already present in AndroidManifest.xml")
else:
    print(f"Manifest not found at {manifest_path}")

