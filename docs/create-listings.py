#!/usr/bin/env python
import glob
import os
import shutil
from ruamel.yaml import YAML

yaml = YAML(typ="rt")


def main():
    for listing in ("modules", "subworkflows"):
        dirpath = os.path.join("docs", listing)
        if os.path.exists(dirpath):
            shutil.rmtree(dirpath)
        os.mkdir(dirpath)
        write_listing_components(listing)


def write_listing_components(mtype):
    with open(f"docs/templates/modules.qmd", "r") as infile:
        template = infile.read()
    listing = [
        write_qmd(meta, template, mtype=mtype)
        for meta in get_yaml_globs(f"{mtype}/**/meta.yml")
    ]
    write_yaml_object(listing, f"docs/{mtype}/{mtype}.yml")


def write_qmd(meta, template, mtype="modules"):
    out_yml = f"docs/{mtype}/{meta['name']}.yml"
    with open(out_yml, "w") as outfile:
        yaml.dump(meta, outfile)
    qmd = template.format(
        title=meta["name"],
        subtitle=meta["description"],
        yaml_file=out_yml,
        module_name="/".join(meta["name"].split("_")),
        module_type=mtype,
        module_path=meta["filename"].rstrip("meta.yml"),
    )
    out_qmd = f"docs/{mtype}/{meta['name']}.qmd"
    with open(out_qmd, "w") as outfile:
        outfile.write(qmd)
    meta["title"] = meta.pop("name")
    meta["subtitle"] = meta.pop("description")
    meta["categories"] = meta.pop("keywords")
    meta["path"] = f"/docs/{mtype}/{meta['title']}.qmd"
    return meta


def get_yaml_globs(infileglob):
    for filename in glob.glob(infileglob, recursive=True):
        with open(filename, "r") as infile:
            yaml_meta = yaml.load(infile)
            yaml_meta["filename"] = filename
            yield yaml_meta


def write_yaml_object(object, outfilename):
    with open(outfilename, "w") as outfile:
        yaml.dump(object, outfile)


if __name__ == "__main__":
    main()
