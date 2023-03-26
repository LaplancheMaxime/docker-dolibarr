"""Module with docs methods."""
# -*- coding: utf-8 -*-
from . import helpers
from . import dolibarr


MARKDOWN_MARKER = [
    "DockerTags",
    "SupportedArchitectures",
    "HowToRun",
    "Header"
]

DOCS_TO_UPDATE = [
    "README.md",
    "docs/README.md",
    "docs/README_DOCKER_HUB.md",
]

def update_docs(versions, docker_archis, latest_version):
    """Process to update Readme.md."""
    # Open the file for reading and writing
    for doc in DOCS_TO_UPDATE:
        print(doc)
        with open(f"{doc}", "r+", encoding="utf-8") as file:
            # Read the contents of the file
            content = file.read()

            for marker in MARKDOWN_MARKER:
                print(marker)
                start_marker = f"<!-- >{marker} -->"
                end_marker = f"<!-- <{marker} -->"
                start = content.find(start_marker)
                end = content.find(end_marker)
                print(start, end)
                if start != -1 and end != -1:
                    start += len(start_marker)
                    print(start, end)
                    new_content = get_new_content(marker, versions, docker_archis, latest_version)
                    content = content[:start] + new_content + content[end:]

            # Move the file pointer to the beginning of the file
            file.seek(0)
            # Write the new content to the file
            file.write(content)
            # Truncate the file to erase any remaining content after the new content
            file.truncate()

def get_new_content(marker,versions, docker_archis, latest_version):
    """Get content by marker."""
    match marker:
        case 'DockerTags':
            return get_table_tags(versions, docker_archis, latest_version)
        case 'SupportedArchitectures':
            lines = ""
            for archi in docker_archis:
                lines += f"  - [`{archi}`](https://hub.docker.com/r/{archi}/php/)\n"

            result = "\n## Quick reference\n\n"
            result += "- **Supported architectures**:"
            result +=  "([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))\n"
            result += lines
            return result
        case "HowToRun":
            with open("docs/includes/_HowToRun.md", "r", encoding="utf-8") as file:
                return file.read()
        case "Header":
            with open("docs/includes/_Header.md", "r", encoding="utf-8") as file:
                return file.read()
        case _:
            return f"NOT SUPPORTED MARKER : {marker}"

def get_table_tags(versions, docker_archis, latest_version):
    """Get tags table."""
    # Initialize the variable to keep track of the last major version processed
    readme_table_tags = get_table_tags_header()
    last_version=''
    # Loop over the versions list
    for version in versions:
        # Skip current iteration if major version is same as previous version
        if last_version == version[:4]:
            continue

        # Get the major version from the current version
        major_version = version[:4]

        # Update the last version variable
        last_version = major_version

        # Check if the current version is greater than or equal to the minimum version
        if version >= dolibarr.MIN_VERSION:
            # Loop over the variants list
            for variant in dolibarr.VARIANTS:

                # Add the major version to the table row for the Docker tags
                readme_table_tags += f"|[{major_version}](./images/{major_version})"

                docker_tags = helpers.get_docker_tags(
                    major_version,
                    latest_version,
                    variant,
                    version
                )
                docker_tags_formated = " ".join(["`{}`".format(tag) for tag in docker_tags.split()])

                # Add the Docker tags and the architectures to the table row
                readme_table_tags += f"|{docker_tags_formated}|"
                readme_table_tags += ", ".join(docker_archis)
                readme_table_tags += f"|{dolibarr.get_php_version(major_version)}|\n"
    return readme_table_tags


def get_table_tags_header():
    """Get header of tags table."""
    return """
|Version|Tags|Architecture|PHP|
|---|---|---|---|
"""
