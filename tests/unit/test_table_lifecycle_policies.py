from datetime import date
import json
import pathlib


def load_table_lifecycle_policies(table_name):
    return json.loads(pathlib.Path(f"./../../src/conf/tables/{table_name}.json").read_text())

def test_table_has_lifecycle_and_lifecycle_storage():
    table_lifecycle_policies = load_table_lifecycle_policies("table1")
    print(table_lifecycle_policies)
    assert 17 == 18