from PIL import Image
import os


def create_atlas(input_dir, output_path, width, height, columns):
    images = sorted(os.listdir(input_dir))
    rows = (len(images) + columns - 1) // columns
    new_image = Image.new("RGBA", (width * columns, height * rows), (250, 250, 250, 0))

    for i, img_file in enumerate(images):
        img_path = os.path.join(input_dir, img_file)
        img = Image.open(img_path).resize((width, height))
        row = i // columns
        col = i % columns
        new_image.paste(img, (col * width, row * height))

    new_image.save(output_path, "PNG")


if __name__ == "__main__":
    atlases = [
        # input_dir, output_path, width, height, columns
        ("art/1x", "assets/1x/jokers.png", 71, 95, 10),
        ("art/2x", "assets/2x/jokers.png", 142, 190, 10),
    ]

    for atlas in atlases:
        create_atlas(*atlas)
