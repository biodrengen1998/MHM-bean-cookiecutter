---
title: {{ cookiecutter.project_name }}
---
<!-- ADD DATE; AUTHOR, VERSION ETC. ABOVE -->


Project description
-------
<!-- ADD HERE -->

Folder structure (extended version)
-------

```plaintext
{{ cookiecutter.project_name }}
├── input
│   ├── data
│   └── metafiles
│       ├── {{ cookiecutter.project_slug }}_gene_symbols.txt
│       ├── {{ cookiecutter.project_slug }}_guide_list.csv
│       └── {{ cookiecutter.project_slug }}_sample_list.csv
├── metadata.yml
├── notebooks
├── output
│   ├── count
│   ├── filter
│   ├── profile
│   ├── qc
│   └── results
├── README.md
└── scripts
    └── run_bean_{{ cookiecutter.project_slug }}.sh
```

Credits
-------

This package was created with Cookiecutter and the `https://github.com/hds-sandbox/cookiecutter-template` project template.
