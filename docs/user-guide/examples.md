# Examples

## Html examples
- Example 1.html: Two small pathways showing 9 elements.
- Example 2.html: Four small pathways showing 9 elements. The size is ajusted to the screen.
- Example 3.html: Two pathways EC00010.
- Example 4.html: Four pathways EC00010 (only the two pathways from the left have an alignment defined).

## Example 5. Django project. How to start.

### Requeriments
- virtualenvwrapper, to install pip requeriments.txt

### Installation

```bash
git clone https://github.com/rafelbennasar/pathway-displayer.git pathway-displayer
cd pathway-displayer/examples/example5/
mkvirtualenv pathway-displayer
pip install -r requeriments.txt
python manage.py runserver
```

- Now you can access with your browser to http://127.0.0.1:8000 and you should see the same as in the example 1.
- or, if you go to http://127.0.0.1:8000/?fetch=00010&times=2 it will load the pathway EC00010, two times.
- or, if you go to http://127.0.0.1:8000/?fetch=00330&times=2 it will load the pathway EC00330, two times.
- or, if you go to http://127.0.0.1:8000/?fetch=00010&times=1 it will load the pathway EC00010, one time.
- or, if you go to http://127.0.0.1:8000/?fetch=00010&times=4 it will load the pathway EC00010, four times.


