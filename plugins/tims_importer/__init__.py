from os import environ
from click import echo, secho, style
from pathlib import Path
import sparrow

from .et_redux_importer import ETReduxImporter
from .import_metadata import import_metadata as _import_metadata


@sparrow.task(name="import-xml")
def import_xml(fix_errors: bool = False, redo: bool = False):
    """
    Import Boise State XML files
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
    importer = ETReduxImporter(db)
    files = path.glob("**/*.xml")
    importer.iterfiles(files, fix_errors=fix_errors, redo=redo)


@sparrow.task()
def import_metadata(download: bool = False):
    """
    Import IGSN metadata from SESAR
    """
    _import_metadata(download=download)