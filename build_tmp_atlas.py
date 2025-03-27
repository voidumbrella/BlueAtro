#!/bin/python3

# This exists to automatically build crappy sprites during development.
import os
import io
import json
from PIL import Image, ImageEnhance
from http import client

STUDENTS = {
    0: "neru",
    1: "asuna",
    2: "karin",
    3: "akane",
    4: "toki",
    5: "yuuka",
    6: "noa",
    7: "koyuki",
    8: "rio",
    9: "koharu",
    10: "hanako",
    11: "hifumi",
    12: "azusa",
    13: "miyako",
    14: "saki",
    15: "miyu",
    16: "moe",
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
    bands = [b.resize(size) for b in bands]
    img = Image.merge("RGBA", bands)
    enhancer = ImageEnhance.Brightness(img)
    img = enhancer.enhance(0.9)

    img_w, img_h = img.size

    offset = ((blank_w - img_w) // 2, (blank_h - img_h) // 2)
    blank.paste(img, offset, img)
    blank.save(path, "PNG")


def get_img(key):
    api = "schaledb.com"
    path = f"/images/student/lobby/{key}.webp"
    conn = client.HTTPSConnection(api)
    conn.request("GET", path)
    return Image.open(io.BytesIO(conn.getresponse().read()))


if __name__ == "__main__":
    map = {}
    with open(".students.json") as j:
        students = json.load(j)
        for id, student in students.items():
            map[student["PathName"].lower()] = id

    for id, key in STUDENTS.items():
        path_1x = f"art/students/1x/{id:03d}_{key}.png"
        path_2x = f"art/students/2x/{id:03d}_{key}.png"

        print(f"{id:03d}_{key}: building")
        img = get_img(map[key])
        save_sprite(img, path_1x)
        save_sprite(img, path_2x, True)
