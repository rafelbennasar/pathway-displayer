
# How is a pathway defined?
A *pathway* has three attributes:
- ID
- Title
- Description

# How are compounds defined?
A *compound* has six attributes:
- id: <integer>.
- label: <string>.
- position: <tuple: int>. [x, y].
- size: <tuple: int>. [width, height]
- shape: <string>. "square" or "circle".
- color: <tuple: string>. [default, mouseover]

# How are reactions defined?
A *reaction* has five attributes:
- id: <integer>.
- label: <string>.
- compound1_id: <int> ID from the first compound.
- compound2_id: <int> ID from the second compound.
- type: <string>. "reversible" or "irreversible".


Steps:
1. Load the library:
```javascript
<script src=""></script>
```

1. Declare the variable canvas = iEnhancedCanvas().
```javascript
<canvas id='canvas_pathway'>
```
2. Create N pathways.
```javascript
var p1 = canvas.new_pathway(id = 1, title = "Title 1", description = "Description");
var p2 = canvas.new_pathway(id = 1, title = "Title 2", description = "Description");
[...]
var p3 = canvas.new_pathway(id = 1, title = "Title 3", description = "Description");
```
2.1. Add compounds to each pathway.
```javascript
    compound_list = [

        {
            id: '1',
            label: "label 1",
            position: [200, 200],
            size: [40, 20],
            shape: "square",
            color: ["red", "blue"]
        },

        {
            id: '2',
            label: "label 2",
            position: [100, 100],
            size: [40, 20],
            shape: "square",
            color: ["#ad2", "blue"]
        },

        // [...]


        {
            id: '9',
            label: "label 9",
            position: [300, 300],
            size: [40, 20],
            shape: "square",
            color: ["#ad2", "blue"]
        },

    ]
    p1.add_compound_list(compound_list)
    ```
4. Add reactions to each pathway.
```javascript
reaction_list = [

    {
        id: '1',
        label: 'label 1 pathway 1',
        compound1_id: '1',
        compound2_id: '2',
        type: 'reversible'
    },
    // [...]

    {
        id: '8',
        label: 'label 1 pathway 1',
        compound1_id: '1',
        compound2_id: '9',
        type: 'reversible'
    },

]
p1.add_reaction_list(reaction_list)
```

3. Call canvas.setup() functions
```javascript
    canvas.setup();
```

4. Add alignment results between pathways.
```javascript
    canvas.add_result(result)
```

