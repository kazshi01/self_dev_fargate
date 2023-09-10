import json
import sys

def main(input_file, output_file):
    with open(input_file, 'r') as f:
        data = json.load(f)

    filtered_data = {
        "family": data.get("family"),
        "taskRoleArn": data.get("taskRoleArn"),
        "executionRoleArn": data.get("executionRoleArn"),
        "networkMode": data.get("networkMode"),
        "containerDefinitions": data.get("containerDefinitions"),
        "volumes": data.get("volumes"),
        "placementConstraints": data.get("placementConstraints"),
        "requiresCompatibilities": data.get("requiresCompatibilities"),
        "cpu": data.get("cpu"),
        "memory": data.get("memory"),
    }

    with open(output_file, 'w') as f:
        json.dump(filtered_data, f)

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    main(input_file, output_file)
