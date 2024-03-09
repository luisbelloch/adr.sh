# adr.sh - simple ADR management

This repo contains a simple script to create ADRs and RFCs from a template. Single bash-script, nothing fancy. I even don't know why I took the time to publish this.

This script has dependencies with `bash` and other unix tools you normally have, such as `tr`, `find`, `sort` and `tail`.

### Installing & usage

Just copy the last version from the git repository:

```bash
curl -O https://raw.githubusercontent.com/luisbelloch/adr.sh/master/adr.sh
chmod +x adr.sh
```

Usage is very simple, just place the title after the script name, it should create a new file and modify the template to update the serial number.

```bash
$ ./adr.sh your fancy title goes here
Created ADR: ex001_your_fancy_title_goes_here.md
```

Have fun.

### Customizations

Inside `adr.sh` script there are some lines controlling the prefix, the working directory and or the template file to be used. They can be controlled using environment variables:

```bash
ADR_PREFIX=adr
ADR_FOLDER=.
ADR_TEMPLATE=./template.md
```

Append it to the beginning to change the values:

```bash
ADR_PREFIX=bar ./adr.sh your title
Created ADR: bar001_your_title.md
```

Please make sure that the file has somewhere the string `EX001.` so it can properly replace the title.

### What's an ADR? And a RFC?

Both are collaboration tools.

- ADR states for [architectural decision records]() and the idea is to capture all the technical decisions a team has been taking over time. The template used in this repository follows the [lightweight](https://github.com/peter-evans/lightweight-architecture-decision-records) version. [Gov.uk website](https://github.com/alphagov/govuk-aws/tree/main/docs/architecture/decisions) has very nice examples.
- RFCs are the initials for _request for comments_. They are everywhere, it's a [very old mechanism](https://www.rfc-editor.org/rfc/rfc8700.html) to communicate ideas and create discussions. Oxide computer has a very nice blogpost on [how they do RFDs](https://oxide.computer/blog/a-tool-for-discussion).

### Why?

All tools came with a ton of dependencies on it, `bash` is everywhere.

### Other tools

A list of real tools can be found in [ADR site](https://adr.github.io/#decision-capturing-tools).

### Contributing

Contributions are welcome, particularly the ones focused on removing 3rd dependencies from the bash script.

Script comes with some tests, run them with:

```
$ ./adr_test.sh
PASS creates_initial_file
PASS created_file_shares_template
PASS next_one_increases_numeration
PASS numeration_is_also_increased_in_copied_template
```
