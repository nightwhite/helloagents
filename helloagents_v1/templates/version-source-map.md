# 版本号定位参考（主 > 次）

当需要更新版本号或生成 CHANGELOG 条目时，优先从“主来源”读取并更新版本号；如不存在，再使用“次来源”。

| 语言/框架 | 主来源 | 次来源 |
|----------|--------|--------|
| JavaScript/TypeScript | package.json → version | index.js/ts → VERSION 常量 |
| Python | pyproject.toml → [project].version | setup.py / __init__.py → __version__ |
| Java (Maven) | pom.xml → <version> | - |
| Java (Gradle) | gradle.properties / build.gradle → version | - |
| Go | Git tag | - |
| Rust | Cargo.toml → [package].version | - |
| .NET | .csproj → <Version>/<AssemblyVersion> | - |
| C/C++ | CMakeLists.txt → project(...VERSION) | 头文件 → #define PROJECT_VERSION |

