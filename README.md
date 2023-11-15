<a name='readme-top'></a>

<br />
<div align='center'>
<h3 align='center'>Agent Factory</h3>
<h4 align='center'>Intelligent Entertainment</h4>
</div>
<br>

## About
This repository hosts the **agent-factory** project split between

*Infrastructure* and *Content*.

Data that is classified as Infrastructure are the support tools and metadata

that enable product-lifecycle operations.

- Tools
- Development process specifications
- Product and Software requirement specifications
- Developer environments
- Integrations
- Docker images
- Scripts
- Libraries
- Metadata
- Programs

While Content refers to data generated with the intent to advance the project

but not document or support the project. Content uses infrastructure while

infrastructure should never make use of the content.

### Content
All Content data is nested under the `dep/` and `usr/` secondary hierarchies such as:

    agent-factory/dep/software
    agent-factory/usr/pnoulis

where dep is an abbrevation for department and usr for user.

Each subdirectory is either part of a ([logical](#logical-submodule)) git submodule or a cloud storage

space depending on their needs.

For example the design department has no need for a VCS and as such the directory

`agent-factory/dep/marketing` is used only as a cloud storage space.

By contrast the software department needs both a VCS and on occasion a

cloud storage space:

    agent-factory/dep/software/.git
    agent-factory/dep/software/cloud

Where the cloud subdirectory is not tracked by the git submodule and

is part of a cloud storage space.

<a name="logical-submodule">However</a> to avoid the use of git submodules,

subdirectories under `dep/` or `usr/` that need to make use of a VCS shall

share(logical submodule) the project's root repository or superproject

in git terminology.

If the project grows to such a size where the use of submodules would

reduce complexity instead of increasing it, they can be split.

### Infrastructure
Infrastructure data is placed under the root directory and are subject

to classification generally following the scheme:

1) departments

    agent-factory/software
    agent-factory/marketing
    agent-factory/sales

2) topics

    agent-factory/cloud-hosting/digital-ocean
    agent-factory/google/
    agent-factory/clickup/
    agent-factory/authorization/

3) tools

    agent-factory/tools/gpg
    agent-factory/tools/rclone

4) scripts

    agent-factory/scripts/

## Getting Started


<p align='right'>(<a href="#readme-top">back to top</a>)</p>

### Prerequisites

<p align='right'>(<a href="#readme-top">back to top</a>)</p>

### Installation

```sh
git clone git@github.com:pnoulis/agent-factory.git
cd agent-factory
./configure
``**

## Terminology

**Infrastructure**

    Data required to manage operations across a projects full development lifecycle.

**Content**

    Data dependend on the Infrastructure.

**Project**

    A Project represents a conceptual container used to refer to any activity
    individual or collaborative towards an intended goal. For example the
    agent-factory project encapsulates IE's group decision to build escape rooms
    for sale. The agent-factory project therefore refers to all activity
    related towards that aim.

**Department**

    A Department is an organizational unit representing different areas of
    responsibility. For example, large-enough project's may be owned by
    the software and sales department. The software department is responsible
    for developing software for the project while the sales department is
    responsible for selling it.

**Package**

    A Package is a collection of source files in the same directory that are
    compiled together.

**Module**

    A Module is a collection of packages that are treated as a single unit.


<p align='right'>(<a href="#readme-top">back to top</a>)</p>

## Usage

<p align='right'>(<a href="#readme-top">back to top</a>)</p>

## Contact

pavlos.noulis@gmail.com

<p align='right'>(<a href="#readme-top">back to top</a>)</p>

