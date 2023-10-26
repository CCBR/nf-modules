#!/usr/bin/env python
import glob
import os
import shutil
from ruamel.yaml import YAML

yaml = YAML(typ="rt")
yaml_str = YAML(typ=["rt", "string"])


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
    for nf_meta in get_yaml_globs(f"{mtype}/**/meta.yml"):
        write_qmd(nf_meta, template, mtype=mtype)


def write_qmd(nf_meta, template, mtype="modules"):
    # write out nextflow module meta.yml as-is
    out_nf_yml = f"docs/{mtype}/{nf_meta['name']}.yml"
    with open(out_nf_yml, "w") as outfile:
        yaml.dump(nf_meta, outfile)

    # create metadata for quarto file & listing
    qmd_dict = {
        "title": nf_meta["name"],
        "subtitle": nf_meta["description"],
        "categories": nf_meta["keywords"],
        "params": {
            "nf_yaml_file": out_nf_yml,
            "module_name": "/".join(nf_meta["name"].split("_")),
            "module_type": mtype,
            "module_path": nf_meta["filename"].rstrip("meta.yml"),
        },
    }
    extra_meta = "\n" + yaml_str.dump_to_string(qmd_dict)

    # generate quarto file from template
    template_split = template.split("---")
    template_split[1] = "\n".join([extra_meta, template_split[1]])
    qmd_str = "---".join(template_split)
    with open(f"docs/{mtype}/{nf_meta['name']}.qmd", "w") as outfile:
        outfile.write(qmd_str)


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
