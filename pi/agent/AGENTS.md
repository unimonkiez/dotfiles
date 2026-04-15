# Refined Cursor AI Rules

1. General Principles
- Always read files before writing to them in case user changes were made between operations. If changes are detected, analyze them carefully, preserve user changes, mention them explicitly, and consider them for subsequent operations.
- No YAGNI: Do not over-engineer. Write code only for the current requirement.
- Maintainability First: Prioritize code that is easy to refactor over code that is "clever" or "concise."

2. Code Style & Logic
- Focused Functions: Every function must do exactly one thing. If a function exceeds 20 lines, evaluate it for splitting.
- Self-Documenting Code: Strictly no comments in code. If you feel a comment is necessary, rename your variables or functions to provide the missing context.
- Enum-First Typing: Never hardcode strings or integers when an Enum can be used.
- Rule: If an Enum exists, it must be the key/type for any associated maps, records, or switch statements.
  Example: In TypeScript, use Record<MyEnum, ValueType>. In other languages, use the idiomatic equivalent to ensure exhaustive checking.
- Type Inference: Never annotate the type of a variable binding when the compiler can infer it. Place type hints on the constructor or method call instead.
  Bad:  let mut map: HashMap<String, Vec<u32>> = HashMap::new();
  Good: let mut map = HashMap::<String, Vec<u32>>::new();
  Bad:  let items: Vec<_> = iter.collect();
  Good: let items = iter.collect::<Vec<_>>();

3. Dependency & Import Management
- Namespace Imports: Avoid named imports. Use the top-level module/namespace to keep the origin of a method clear.
- React: Use React.useState, React.useEffect.
- Node.js: Use fs.promises.readFile, path.join.
- Rust Specifics: Zero imports. Do not use use statements. Always use absolute, full module paths (e.g., std::collections::HashMap::new()).
- Python Specifics: Prefer import module and module.function() over from module import function.

4. Implementation Guidelines
- Exhaustive Handling: When working with Enums or Unions, always implement exhaustive checks (e.g., default cases that throw errors or match arms for every variant).
- Immutable by Default: Use const, readonly, or immutable data structures unless mutation is strictly required for performance or logic.
- Collect over Mut: Never use a mutable accumulator + push loop when an iterator + collect achieves the same result. Only introduce mut when no functional alternative exists.
  Bad:  let mut items = Vec::new(); for x in src { items.push(f(x)); }
  Good: let items = src.into_iter().map(f).collect::<Vec<_>>();