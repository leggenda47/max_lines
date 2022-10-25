# max_lines

To install add the following to pubspec.yaml:

```yaml
dependencies:
  custom_lint:
    git:
      url: https://github.com/leggenda47/dart_custom_lint.git
      ref: main
      path: packages/custom_lint
  max_lines:
    git:
      url: https://github.com/leggenda47/max_lines.git
      ref: main
```

To set custom parameters for `max_lines` add the following to analysis_options.yaml:

```yaml
params:
  max_lines:
    line_count: 123
```
