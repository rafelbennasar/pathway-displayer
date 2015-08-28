# Introduction

pathway-displayer.js is a javascript library to display multiple pathways and show
the relationship between them.

# Download
In order to get the latest version go to the github account.

# Features

- The library allows you to draw one or more pathways in the same canvas (actually,
as many pathways as you want).
- Automatically, it will be selected the best zoom to fit all pathways in the screen.
- It's fast and light. You can draw many pathways (I've test it with 10 pathways) 
without any proplem.
- In order to maintain a cleaner canvas, if there are two or more compounds 
together, they are groupped creating a new "virtual compound". Afterwards, just
before drawing, the reactions between compounds are also minimized (in the
same way how KEGG does it).
- Afterwards, you can link one reactions from the first pathway to a reaction 
from the second pathway or the third pathway, etc.


# Examples

# TODO

1. Allow multple layouts when there's more than 2 pathways: inline, pile, 
squares, etc.
2. Compounds still cannot be moved.


...



# Known bugs
1. If there are more than two pathways and one reaction from pathway A
is aligned with two or more reactions from different pathways,
may only be highlighted the reaction from the last pahtway.



## Getting Help

If you stumble upon a bug or don't understand some feature, please do not
hesitate to open an issue or send me an email.


## License

pathway-displayer.js is released under the GPL v3 license.
