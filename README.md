# Jack-o-Lantern 2015

I have four bright neo-pixel plates and a couple of smaller LED grids. I might
as well put them to work in a Jack-O-Lantern this year.

### As seen on Youtube
[![](art/youtube.jpg)](https://www.youtube.com/) <br>
https://www.youtube.com/watch?v=z5ygn6gWkBM&t=12s

LED Grid:
[http://www.adafruit.com/product/902](http://www.adafruit.com/product/902)

NeoPixel Plate:
[http://www.adafruit.com/products/1487](http://www.adafruit.com/products/1487)

Here is the hardware and pumpkin:
![](art/IMG_0288.JPG)

The plan is to use the two smaller displays for eyes. Three of the plates will make a mouth. I'll offset them to better allow a smile. I'll use the center stripe of the fourth for a nose.

I already have the propeller software going. I was planning a Circuit Cellar article (of course) on the grid mapping. This project will be a good addition to the article.

Here is another project using LED grids for eyes:
[https://www.youtube.com/watch?v=e3O-ti5n6jw](https://www.youtube.com/watch?v=e3O-ti5n6jw)

## Schematics
![](art/JackSchematics.png)

## The Jack Language
I create a DSL (domain specific language) for the project. I wrote a compiler for it in Java. The compiler outputs Propeller DAT sections for compiling into the propeller. Have a look at "nose.txt" and "mouth.txt" to see the language in action. The "Jack2015.spin" contains the interpreter and the compiled scripts.

The code launches 3 copies of the Jack interpreter -- one for the eyes, one for the nose, and one for the mouth. They run independently of one another.

## Photos

![](art/IMG_0291.JPG)

![](art/IMG_0299.JPG)


