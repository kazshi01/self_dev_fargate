import json
import sys

def main(input_file, output_file):
    with open(input_file, 'r') as f:
        data = json.load(f)

    # Extracting the taskDefinition content
    task_definition_data = data.get("taskDefinition", {})

    filtered_data = {}
    keys = [
        "family", 
        "taskRoleArn", 
        "executionRoleArn", 
        "networkMode", 
        "containerDefinitions", 
        "volumes", 
        "placementConstraints", 
        "requiresCompatibilities", 
        "cpu", 
        "memory"
    ]

    for key in keys:
        if key in task_definition_data:
            filtered_data[key] = task_definition_data[key]

    with open(output_file, 'w') as f:
        json.dump(filtered_data, f)

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    main(input_file, output_file)
