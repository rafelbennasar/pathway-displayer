
# Quick start

```javascript
    var canvas = new window.iEnhancedCanvas(canvas_id = "canvas_pathway");

    p1 = canvas.new_pathway(id = 1, title = "Title 1", description = "Description");
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

    p2 = canvas.new_pathway(id = 2, title = "Title 2", description = "Description");
    compound_list = [

        {
            id: '1',
            label: "label 1",
            position: [200, 200],
            size: [40, 20],
            shape: "square",
            color: ["red", "blue"]
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
    p2.add_compound_list(compound_list)
    reaction_list = [

        {
            id: '1',
            label: 'label 1 pathway 2',
            compound1_id: '1',
            compound2_id: '2',
            type: 'reversible'
        },
        // [...]


        {
            id: '8',
            label: 'label 1 pathway 2',
            compound1_id: '1',
            compound2_id: '9',
            type: 'reversible'
        },

    ]
    p2.add_reaction_list(reaction_list)

    // necessary to call this function BEFORE putting the result.
    canvas.setup();



    // Now we get this result with an ajax call ... or we already have it
    // from the beginning. 
    result = [
        {
            'id': 2,
            'pathway1_id': 0,
            'reaction1_id': 2,
            'color1': 'orange',
            'pathway2_id': 1,
            'reaction2_id': 2,
            'color2': 'blue',
        },
        // [...]

        {
            'id': 8,
            'pathway1_id': 0,
            'reaction1_id': 8,
            'color1': 'orange',
            'pathway2_id': 1,
            'reaction2_id': 8,
            'color2': 'blue',
        },


    ]
    // we add the result of our calculations.
    canvas.add_result(result)
```
