#!/bin/python3

# This exists to automatically build crappy sprites during development.
import os
import io
from PIL import Image
from http import client

KEYS = {
    "neru",
}


def save_sprite(img, path, double_size=False):
    blank = (
        "art/students/2x/2x_blank.png"
        if double_size
        else "art/students/1x/1x_blank.png"
    )
    blank = Image.open(blank)
    blank_w, blank_h = blank.size
    size = (65 * 2, 55 * 2) if double_size else (65, 55)

    # https://stackoverflow.com/questions/13027169/scale-images-with-pil-preserving-transparency-and-color
    img = img.convert("RGBA")  # why do I need this
    bands = img.split()
    print(len(bands))
    bands = [b.resize(size) for b in bands]
    img = Image.merge("RGBA", bands)

    img_w, img_h = img.size

    offset = ((blank_w - img_w) // 2, (blank_h - img_h) // 2)
    blank.paste(img, offset, img)
    blank.save(path, "PNG")


def get_img(key):
    api = "api.ennead.cc"
    path = f"/buruaka/image/lobby/{key}"
    conn = client.HTTPSConnection(api)
    conn.request("GET", path)
    return Image.open(io.BytesIO(conn.getresponse().read()))


if __name__ == "__main__":
    for id, key in enumerate(KEYS):
        path_1x = f"art/students/1x/{id:03d}_{key}.png"
        path_2x = f"art/students/2x/{id:03d}_{key}.png"
        if os.path.exists(path_1x) and os.path.exists(path_2x):
            print(f"{id:03d}_{key}: skip")
            continue
        print(f"{id:03d}_{key}: building")
        img = get_img(key)
        save_sprite(img, path_1x)
        save_sprite(img, path_2x, True)
