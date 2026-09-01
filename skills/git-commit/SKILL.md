---
name: git-commit
description: Commit changes following the repo's branch and commit conventions. Use when asked to commit, create a branch, or prepare a commit. Covers branch creation rules (never commit directly on main), Conventional Commits format, and Gitmoji prefixes.
---

# Git Commit

Commit and branch rules for this repository. Apply them whenever a commit or branch operation is requested.

## General rule

Ne commiter que si cela est demandé explicitement. Ne jamais commiter de soi-même sans demande.

## Branches

Créer une branche dédiée pour chaque changement (ex. `fix/resume-expired-streams`, `feat/next-marks-watched`) et ne jamais commiter directement sur `main`, en respectant les conditions suivantes :

- Créer la branche dédiée **uniquement si l'on se trouve déjà sur `main` ou `master`**, et **avant de faire le commit**.
- Si l'on est déjà sur une branche de travail (autre que `main`/`master`), ne pas créer de nouvelle branche : commiter directement dessus.

## Commit format

Les commits doivent respecter la spec [Conventional Commits](https://www.conventionalcommits.org/fr/v1.0.0/) et être préfixés par un [Gitmoji](https://gitmoji.dev) pertinent.

```
<gitmoji> <type>(scope optionnel): <description>
```

Exemples :

```text
✨ feat(player): marque la vidéo comme lue sur le bouton suivant
🐛 fix(player): corrige la reprise de lecture sur les streams expirés
📝 docs: documente le format des commits
🚀 chore(deps): met à jour les dépendances
```

Règles :

- Le type suit Conventional Commits : `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Pour un commit de type `feat`, prendre **aléatoirement** une icône parmi : 🍪 🍔 🍨 🍕 🥧 🍰 🍦 🧁 🍩 🍡 🍭 🦄 🍄 🍯 🍫 🍬 🥦 🌶️ 🍆 🥑 🐵 🐷 🐯 🦁 🐻 🐼 🐱 🦊 🦃 🐔 🐣 🐥 🦋 🌼 🌸 🌷 🌻 🐢 🌞 🐸 🤖 🧑‍💻 👨‍💻 👩‍💻 👩 🚀 💡 🦾 ✨ 🪄 ⚡ 🧬 🫶 👍 👍🏾 🧢 🧿 🗿 📈 🫟 🎈 🎸 🆕 🔨 🚧 🏅.
- Pour un commit de type `fix`, prendre **aléatoirement** une icône parmi : 🐛 🐝 🕷️ 🐞 🐜.
- Pour les autres types, l'emoji doit refléter le type (📝 pour `docs`, etc.).
- La description doit être courte, à l'impératif, sans majuscule initiale ni point final.

## Workflow

Avant de commiter, toujours :

1. Vérifier l'état avec `git status` et `git diff`.
2. Se trouver sur la bonne branche (`git branch --show-current`), en créer une dédiée si nécessaire selon les règles ci-dessus.
3. Ne commiter que les fichiers voulus (`git add` ciblé), jamais de secrets.
4. Écrire le message au format `<gitmoji> <type>(scope optionnel): <description>`.
