#!/bin/python3

from PIL import Image
import os


def create_atlas(input_dir, output_path, width, height, rows, columns, blank_path):
    images = sorted(os.listdir(input_dir))
    new_image = Image.new("RGBA", (width * columns, height * rows), (250, 250, 250, 0))

    for i, img_file in enumerate(images):
        img_path = os.path.join(input_dir, img_file)
        if img_path == blank_path:
            continue
        img = Image.open(img_path).resize((width, height))
        row = i // columns
        col = i % columns
        new_image.paste(img, (col * width, row * height))

    blank = Image.open(blank_path).resize((width, height))
    for j in range(i, rows * columns):
        row = j // columns
        col = j % columns
        new_image.paste(blank, (col * width, row * height))

    new_image.save(output_path, "PNG")


if __name__ == "__main__":
    atlases = [
        # input_dir, output_path, width, height, rows, columns, blank
        (
            "art/jokers/1x",
            "assets/1x/jokers.png",
            71,
            95,
            10,
            10,
            "art/jokers/1x/1x_blank.png",
        ),
        (
            "art/jokers/2x",
            "assets/2x/jokers.png",
            142,
            190,
            10,
            10,
            "art/jokers/2x/2x_blank.png",
        ),
        (
            "art/enhancements/1x",
            "assets/1x/enhancements.png",
            71,
            95,
            10,
            10,
            "art/enhancements/1x/1x_blank.png",
        ),
        (
            "art/enhancements/2x",
            "assets/2x/enhancements.png",
            142,
            190,
            10,
            10,
            "art/enhancements/2x/2x_blank.png",
        ),
    ]

    for atlas in atlases:
        create_atlas(*atlas)
