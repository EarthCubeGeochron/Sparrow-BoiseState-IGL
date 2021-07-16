from os import environ
from click import command, option, echo, secho, style
from sparrow.context import get_database
from pathlib import Path
from pandas import read_feather
from IPython import embed

@command(name="import-icp-data")
@option("--fix-errors", is_flag=True, default=False)
@option("--redo", is_flag=True, default=False)
def cli(**kwargs):
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

    db = get_database()
    files = path.glob("**/*.feather")
    for file in files:
        df = read_feather(file)
        embed()
        raise
