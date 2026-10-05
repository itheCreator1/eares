Photos and the logo used by the theme. Originals live in `assets/pictures/` at the repository root; these are resized WebP copies made with `scripts/optimize-photo.sh`, for example:

```sh
scripts/optimize-photo.sh assets/pictures/NX3_9750.JPG.jpg dome 2400
```

| File | Original | Where |
|---|---|---|
| `dome.webp` | `NX3_9750` | Front-page hero. The text sits on the right, so the lit dome on the left stays in view. |
| `portico.webp` | `NX3_9755` | Front page, "Καλώς ήρθατε" section. |
| `church-night.webp` | `NX2_1411` | Header photo of the "Η Ένωση" page (copied into the Media Library by `setup.sh`). |
| `school.webp` | `NX3_9764` | Header photo of the "Η Ριζάρειος Σχολή" page (the same way). |
| `logo.webp` | `logo eares.png` | The medallion beside the site title, and on the login screen. 192 px wide. |
| `icon.png` | `logo eares.png` | Browser tab icon (unless a Site Icon is set in the admin). 180 px wide. |

If `dome` or `portico` is missing, the front page falls back to a plain background.

`icon.png` has to be a PNG (phones do not take WebP for home-screen icons), so it is made by hand:

```sh
docker compose exec -T wordpress php -r '
$img = imagescale( imagecreatefromstring( file_get_contents( "php://stdin" ) ), 180, -1, IMG_BICUBIC );
imagealphablending( $img, false );
imagesavealpha( $img, true );
imagepng( $img, "php://stdout", 9 );
' < "assets/pictures/logo eares.png" > wp-content/themes/eares/assets/images/icon.png
```
