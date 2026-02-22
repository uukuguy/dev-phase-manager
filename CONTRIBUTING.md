# Contributing to Phase Manager

Thank you for your interest in contributing to Phase Manager! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **Environment details** (OS, Claude Code version, plugin version)
- **Screenshots or logs** if applicable

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- **Clear use case** for the enhancement
- **Detailed description** of the proposed functionality
- **Examples** of how it would work
- **Potential impact** on existing features

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following the coding standards
3. **Test your changes** thoroughly
4. **Update documentation** if needed
5. **Write clear commit messages**
6. **Submit a pull request** with a comprehensive description

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/phase-manager.git
cd phase-manager

# Link to Claude Code plugins directory
ln -s $(pwd) ~/.claude/plugins/phase-manager

# Test your changes
/list-plan
```

## Coding Standards

### Command Files

- Use Markdown format with YAML frontmatter
- Include clear descriptions and examples
- Follow existing command structure
- Add comprehensive documentation

### Documentation

- Keep README.md up to date
- Update CHANGELOG.md for all changes
- Use clear, professional English
- Include code examples where appropriate

### Commit Messages

Follow conventional commits format:

```
type(scope): subject

body (optional)

footer (optional)
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat(checkpoint): add automatic progress detection
fix(resume-plan): handle missing checkpoint file gracefully
docs(readme): update installation instructions
```

## Testing

Before submitting a PR:

1. Test all modified commands manually
2. Verify integration with superpowers
3. Check for edge cases and error handling
4. Ensure idempotency where applicable

## Documentation

When adding new features:

1. Update README.md with usage examples
2. Add entry to CHANGELOG.md
3. Update command reference if needed
4. Include inline documentation in code

## Questions?

Feel free to:
- Open an issue for discussion
- Ask in GitHub Discussions
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
