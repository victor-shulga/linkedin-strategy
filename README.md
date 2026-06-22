# LinkedIn Strategy Engine

Claude Code plugin (standalone tool): будує **машиночитну LinkedIn-стратегію** в Notion з
профілю людини + сайту компанії. Витяг кроку `01-strategy` із плагіна `content-engine` як
окремий продукт.

## Що робить

З LinkedIn-профілю + сайту → скрейпить профіль (Apify), мову й топ-пости автора, компанію,
реюзить GTM-стратегію якщо є — і збирає **стратегічний конфіг із 9 секцій** у Notion:

1. Цілі, KPI, Commitment
2. ICP + Buyer Persona (JTBD 3 рівні)
3. Ворог + Signature Concept
4. Контент-пілари *(без квот — баланс тримає тижневий планувальник)*
5. Офер-аудит для LinkedIn (скоринг продажності 4 осі × 8 критеріїв)
6. Voice Profile *(з реальних постів)*
7. 6 Viral Levers
8. Distribution Playbook *(2026, van der Blom)*
9. Передісторія + Цінності + Факти-патрони

Це **конфіг для движка, не PDF для клієнта** — секції 4/6/7 машиночитні, їх читають
наступні тули (research, тижневий план, продакшн). У кінці засіває Idea Pool 10–15 ідеями.

## Reference

- `reference/strategy-template.md` — канон 9 секцій + правила заповнення
- `reference/methodology.md` — viral levers, ритм, competence-стратегії, distribution
- `reference/hook-bank.md` — правила хуків (для прикладів у піларах)
- `reference/notion-schema.md` — структура хабу + Idea Pool / Weekly Plans / Posts

## Встановлення

```
/plugin marketplace add victor-shulga/linkedin-strategy
/plugin install linkedin-strategy-engine@linkedin-strategy
```

## Запуск

```
/strategy <person-linkedin-url> <company-site-or-linkedin>
```

## Валідація

```
bash scripts/validate.sh
```

## Зв'язок з content-engine

Витяг кроку `01-strategy` з [content-engine](https://github.com/victor-shulga/content-engine-skills)
у самостійний тул. Reference-файли спільні за походженням — при зміні логіки тримати
синхронними між обома репо (пара: [linkedin-research-engine](https://github.com/victor-shulga/linkedin-research-engine-skills)).

MIT © Victor Shulga
