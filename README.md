A brändi dogg inspired game

https://de.wikipedia.org/wiki/Farbe_(Kartenspiel)
https://sheepolution.com/learn/book/contents
https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle

TODO
- improve draggable object creation (should inherit from a base object type that has default values for transform.x/y, dragging and going home, velocity
- it makes sense in my head that there is only a single object that can be moved at a time, this would mean that i should handle determining which object is being moved, and then only updating the moving for that object (instead of iterating over all objects, as i am doing now), this means that the mousepressed function determines the currently moved object and the update function only updates the position for that object
    - depending on the object, it is simply moved and goes to home when released, but eg the murmel also snaps to the spielfeld, so it is different from karte, so they should be handled differently
- distribute cards to players
- allow card sorting
