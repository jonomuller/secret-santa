# Secret Santa
Program to assign Secret Santa via email.

## Usage

Run the program in Xcode using the following arguments:

1. path to a JSON file formatted as shown below
2. path to an images directory containing images referenced in the JSON file

Parameters can be set in Xcode by navigating to ```Edit Scheme… > Run > Arguments > Arguments Passed on Launch```

## Data Format

* **people**: Array
  * **name**: String
  * **email**: String
  * **image_path**: String (name of image file within ```images/</code>``` directory)
  * **suggestions**: [String]
* **conditions**: Array (pair of names to not be assigned to each other)
  * **first**: String
  * **second**: String
  
### Example
  
```json
{
  "people": [
    {
      "name": "Jono Muller",
      "email": "jonomuller@github.com",
      "image_path": "Jono.png",
      "suggestions": [
        "1",
        "2"
      ]
    }
  ],
  "conditions": [
    {
      "first": "Jono",
      "second": "David"
    }
  ]
}
```
