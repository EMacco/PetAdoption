# Pet Adoption (Form Builder)

This is an iOS application developed with Swift, that allows users to be able to dynamically generate a form using raw JSON data.

# Features

  - Generate a multi-page form with different sections 
  - Validate form data input
  - Toggle visibility of other form elements using a switch
  - Indicate required fields 

# Tech
- Swift
- RxSwift
- RxDataSource
- RxCocoa
- ProgressHUD

# Installation
Clone the repository
```sh
$ git clone https://github.com/EMacco/PetAdoption.git
```

Install the application dependencies.

```sh
$ cd PetAdoption
$ pod install
```

Open the file `PetAdoption.xcworkspace` using Xcode 
Click on the play button at the top left corner to build and run the project

# Usage

In order to generate your own custom form, navigate to Resources folder and click on `pet_adoption.json`
Modify the JSON file using the rules below to generate your own custom form 

### Form JSON Structure
`Form Details:` This is the outermost part of the JSON object that contains details about the form in general
```
{
	id: String
	name: String
	pages: []
}
```

##### Pages:
This is an array of objects that contains details for individual pages of the form.
```
[
	{
		label: String
		sections: []
	},
	{
		label: String
		sections: []
	}
]
```

##### Sections: 
This is an array of objects that contain the various elements that can be found in each individual page
```
[
	{
		label: String
		elements: []
	},
	{
		label: String
		elements: []
	}
]
```

##### Elements: 
These are individual components that the user interacts with.
```
[
	type: String(embeddedphoto, text, yesno, formattednumeric, datetime)
	rules: []
	uniqueId: String
	file: String
	label: String
	isMandatory: Bool
	keyboard: String(numeric, email, normal, password)
	formattedNumeric: String
	mode: String (date, select)
	options: []
]
```

###### Type: 
This represents the type of element you want to display on the screen 
- `embeddedphoto:`  image
- `text:` Normal text field
- `yesno:` Switch toggle
- `formattednumeric:` Formatted text
- `datetime:` Date picker

###### File: 
This contains the `url path` to image that should be displayed

###### IsMandatory: 
This indicates whether the particular element is required or not. It accepts value of type Boolean `true` or `false`

###### Keyboard:
This represents the type of keyboard that should be displayed.
- `FormattedString:` This indicates the pattern in which the text should be - formatted as
- `Mode:` Informs if keyboard should be replaced with a date picker or a normal pickerview
- `Options:` Contains a list of all options that should be displayed in the pickerview

##### Rules: 
This is an array of rules and actions that should be executed when an action occurs
```
[
	condition: String (equal)
	value: String
	action: String (show, hide)
	otherwise: String(show, hide)
	targets: []
]
```

###### Condition: 
The type of comparison we want to carry out between expected and actual values. Currently, the application supports just `equals` to check that two values are the same

###### Value: 
What we will be comparing against

###### Action: 
What to do if the comparison returns `true`. Currently, the application simply supports show and hide to toggle field visibility

###### Otherwise: 
What to do if the comparison returns `false`. Currently the application simply supports show and hide to toggle field visibility

###### Targets: 
This is a list of element IDs that the action will be applied to.

# Example
### JSON Data
```
{
  "id": "form_1",
  "name": "Pet Adoption Application Form",
  "pages": [
    {
      "label": "Page 1",
      "sections": [
        {
          "label": "Welcome to Pets Rescue",
          "elements": [
            {
              "type": "embeddedphoto",
              "file": "https://images.pexels.com/photos/8700/wall-animal-dog-pet.jpg?cs=srgb&dl=animal-collar-dog-8700.jpg&fm=jpg",
              "unique_id": "embeddedphoto_1",
              "rules": []
            }
          ]
        },
        {
          "label": "Basic Info",
          "elements": [
            {
              "type": "text",
              "label": "Your fullname",
              "isMandatory": true,
              "unique_id": "text_1",
              "rules": []
            },
            {
              "type": "text",
              "label": "Email address",
              "isMandatory": true,
              "keyboard": "email",
              "unique_id": "text_2",
              "rules": []
            },
            {
              "type": "formattednumeric",
              "label": "Phone Number",
              "keyboard": "numeric",
              "formattedNumeric": "####-###-####",
              "isMandatory": true,
              "unique_id": "formattednumeric_1",
              "rules": []
            },
            {
              "type": "datetime",
              "mode": "date",
              "label": "Date of Birth",
              "isMandatory": true,
              "unique_id": "datetime_1",
              "rules": []
            },
            {
                "mode": "select",
                "type": "text",
                "label": "Gender",
                "unique_id": "select_1",
                "options": ["Male", "Female"],
                "isMandatory": false,
                "rules": []
            },
            {
                "mode": "select",
                "type": "text",
                "label": "Church",
                "unique_id": "select_4",
                "options": ["Presbyterian", "Anglican", "Methodist"],
                "isMandatory": true,
                "rules": []
            }
          ]
        }
      ]
    }
  ]
}
```

### Screenshot
![Simulator Screen Shot - iPhone 11 - 2019-12-03 at 07 51 05](https://user-images.githubusercontent.com/20377428/70027315-28b42000-15a2-11ea-91a0-228993350cd8.png)

