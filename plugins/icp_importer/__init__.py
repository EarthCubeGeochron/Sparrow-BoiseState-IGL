from os import environ
from click import echo, secho, style
from pathlib import Path
from pandas import read_feather
from IPython import embed
from rich import print
import sparrow


@sparrow.task()
def import_icp_data(fix_errors: bool = False, redo: bool = False):
    """
    Import Boise State LA-ICP-MS data files
    """
    varname = "SPARROW_DATA_DIR"
    env = environ.get(varname, None)
    if env is None:
        v = style(varname, fg="cyan", bold=True)
        echo(f"Environment variable {v} is not set.")
        secho("Aborting", fg="red", bold=True)
        return
    path = Path(env)
    assert path.is_dir()

    db = sparrow.get_database()
    files = path.glob("**/*.feather")
    for file in files:
        df = read_feather(file)
        print(df)
    print("Done")
