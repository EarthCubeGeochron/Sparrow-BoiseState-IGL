from os import environ
from click import echo, secho, style
from pathlib import Path
from pandas import read_feather
from IPython import embed
from rich import print
import sparrow


def convert_to_json(df):
    """
    Convert a feather file to JSON for Sparrow import.
    """
    # Create a sample column that eliminates the last indexing suffix of the analysis column,
    # while saving that suffix in another column. Uses regex. See https://regex101.com/r/ECVDtm/1
    split_samplename = df.loc[:, "analysis"].str.extract(r"^(.+)(_| )(\d+)$")
    print(split_samplename)
    df["sample"] = split_samplename.iloc[:, 0]

    # Maybe we also want to split grainsize fractions here? Can use a similar regex.

    df["session_index"] = split_samplename.iloc[:, 2]

    groups = df.groupby("sample")
    print(f"Grouped data into {len(groups)} samples.")

    for ix, group in groups:
        print(ix, len(group))


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
    # Feather file should be ephemeral, ideally, because we want to preserve links to original files.
    # One way to do this would be to include a "file_path" column in the feather file itself.
    for file in files:
        df = read_feather(file)
        convert_to_json(df)
        print(df)
    print("Done")
