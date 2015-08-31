#Welcome to pathway-displayer.js documentation

# Introduction

pathway-displayer.js is a javascript library to display multiple pathways and show
the relationship between them.

I started this project for my Final Degree Project (hosted in mpalign.uib.es) and later,
 in order to be used easily in other projects I made this library.

It's written in CoffeeScript using the paper.js library. It includes
a complete django example that downloads directly the pathways from KEGG and
a few easy examples to see how it works in each case.

# Download
In order to get the latest version: git clone https://github.com/rafelbennasar/pathway-displayer.git

# Features
- The library allows you to draw one or more pathways in the same canvas (actually,
as many as you want).
- It selects automatically the best zoom to fit all pathways in the screen.
- You can link reactions between all pathways without any limitation and set different colours.
- Virtual compounds/ reactions: In order to maintain a cleaner canvas if there are two or more compounds
together, they are groupped and it's created a new "virtual compound". Later,
the reactions between compounds from the same group are also minimized (in the same way how KEGG does it).



# TODO
1. Allow multple layouts when there's more than 2 pathways: inline, pile,
squares, etc.
2. Compounds still cannot be moved (and maybe will never do).


# Known bugs
1. If there are more than two pathways and one reaction from pathway A
is aligned with two or more reactions from different pathways,
may only be highlighted the reaction from the last pathway.



# Getting Help

If you stumble upon a bug or don't understand some feature, please do not
hesitate to open an issue or send me an email.


# License

License: GPLv3 GPLv3

Copyright (C) 2015 Rafel Bennasar Crespí.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

