
# How is a pathway defined?

A *pathway* has three attributes:

- ID
- Title
- Description

# How are compounds defined?

A *compound* has six attributes:

- id: (integer).
- label: (string).
- position: (tuple: int :: (x, y))
- size: (tuple: int :: (width, height))
- shape: (string). "square" or "circle"
- color: (tuple: string :: (default, mouseover))

# How are reactions defined?

A *reaction* has five attributes:

- id: (integer).
- label: (string).
- compound1_id: (int) ID from the first compound.
- compound2_id: (int) ID from the second compound.
- type: (string). "reversible" or "irreversible".

# How are results defined?

A result has three attributes:

- pathway1_id: (integer). ID from the first pathway.
- pathway2_id: (integer). ID from the second pathway.
- reaction1_id: (integer). This reaction ID is defined in pathway 1.
- reaction2_id: (integer). This reaction ID is defined in pathway 2.
- color1: (string). When it is aligned.
- color2: (string). When mouseover.

It is possible to link the same reaction with more than one pathway/ reactions.


# Steps

1. Load the library:
    ```
    <script src="pathway-displayer.js"></script>
    ```
1. Declare the canvas.
    ```
    <canvas id='canvas_pathway'>
    ```
1. Declare the variable canvas = iEnhancedCanvas().
    ```
    var canvas = new window.iEnhancedCanvas(canvas_id="canvas_pathway");
    ```
3. Create N pathways.

    ```
    var p1 = canvas.new_pathway(id = 1, title = "Title 1", description = "Description");
    var p2 = canvas.new_pathway(id = 1, title = "Title 2", description = "Description");
    [...]
    var p3 = canvas.new_pathway(id = 1, title = "Title 3", description = "Description");
    ```
    
4. Add compounds to each pathway.

    ```
    compound_list = [
            {   id: '1',
                label: "label 1",
                position: [200, 200],
                size: [40, 20],
                shape: "square",
                color: ["red", "blue"]
            }, {id: '2',
                label: "label 2",
                position: [100, 100],
                size: [40, 20],
                shape: "square",
                color: ["#ad2", "blue"]
            },
            // [...]
            {   id: '9',
                label: "label 9",
                position: [300, 300],
                size: [40, 20],
                shape: "square",
                color: ["#ad2", "blue"]
            },
        ];
        p1.add_compound_list(compound_list)
    ```
    
5. Add reactions to each pathway:

    ```
    reaction_list = [
        {   id: '1',
            label: 'label 1 pathway 1',
            compound1_id: '1',
            compound2_id: '2',
            type: 'reversible'
        },
        // [...]
        {   id: '8',
            label: 'label 1 pathway 1',
            compound1_id: '1',
            compound2_id: '9',
            type: 'reversible'
        },
    ]
    p1.add_reaction_list(reaction_list)
    ```
    
6. Call canvas.setup() functions

    ```
        canvas.setup();
    ```
    
7. Add alignment results between pathways.

    ```
        canvas.add_result(result)
    ```
    

