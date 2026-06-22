# Notion-схема Content Engine

Уся персистентна пам'ять engine живе в Notion. Структура:

```
Content Engine                      ← головна сторінка (workspace hub)
├── 🧭 {Client} · Strategy          ← сторінка на клієнта, 10 секцій (strategy-template.md)
├── 💡 Idea Pool                    ← DB: ідеї всіх клієнтів (фільтр по Client)
├── 📅 Weekly Plans                 ← DB: тижневі плани на затвердження
└── 📊 Posts                        ← DB: опубліковані пости + метрики
```

Перший запуск `01-strategy` створює головну сторінку і DB, якщо їх нема. ID сторінок/data sources
після створення записати у `MEMORY.md` проєкту (щоб не шукати щоразу).

---

## DB «Idea Pool»

| Property | Тип | Значення |
|---|---|---|
| Name | title | робоча назва ідеї (1 рядок) |
| Client | select | (your client names) |
| Pillar | select | з секції 7 стратегії клієнта |
| Funnel | select | TOFU / MOFU / BOFU |
| Format | select | text-only / single image / carousel / infographic / lead magnet / video |
| Hook draft | rich_text | чорновий хук (формула: ідея + компетенція) |
| Competence proof | rich_text | чим підкріплена компетенція (число/кейс/досвід) |
| Source | select | research-outlier / call-insight / own-thought / comment-mining / recycle / matrix-expansion |
| Source link | url | лінк на пост-референс / транскрипт / оригінал |
| Score | number | 0–100, рекомендатор |
| Status | select | new → recommended → approved → written → posted → rejected / parked |
| Last used | date | для пауз реюзу (1–3 міс) |
| Notes | rich_text | кут, контекст, чому зараз |

Гейт на вході (3 критерії з methodology §2.1): нема competence proof → ідея не проходить у пул
зі статусом вище `new`.

## DB «Weekly Plans»

| Property | Тип | Значення |
|---|---|---|
| Name | title | «{Client} · Тиждень N (дата-дата)» |
| Client | select | |
| Status | select | draft → sent → approved → in production → done |
| Week start | date | понеділок тижня |

Body сторінки плану: таблиця слотів — день · funnel · формат · **2–3 варіанти ідей** (relation
на Idea Pool) · рядок «чому саме це» на кожен варіант · чекбокс вибору. Після затвердження
вибрані ідеї → Status `approved` в Idea Pool, решта → назад у пул.

## DB «Posts»

| Property | Тип | Значення |
|---|---|---|
| Name | title | хук поста |
| Client | select | |
| Idea | relation | → Idea Pool |
| Pillar / Funnel / Format | select | копія на момент публікації |
| Posted date | date | |
| Post URL | url | |
| Impressions / Likes / Comments / Reposts | number | тижневий інжест (крок 07) |
| ER % | formula | (likes+comments+reposts)/impressions |
| Dialogues started | number | ручний інпут або з DM-трекінгу — головний сигнал якості |
| Leads / Calls | number | атрибуція, ручний інпут |
| Performance tier | select | gem (500+ лайків) / strong / baseline / weak |
| Recycle eligible | formula/checkbox | ≥ 3 міс і tier ≥ strong |

## Зв'язки і цикл даних

```
research (03) ──┐
call insights ──┼──> Idea Pool ──> Weekly Plan (04) ──> production (05/06) ──> Posts
recycle (07) ───┘        ↑                                                      │
                         └────────── score update ← weekly metrics (07) ←───────┘
```

- Рекомендатор (04) читає: Idea Pool (Status=new/recommended, пауза по Last used),
  стратегію клієнта (секції 7–8), Posts (performance prior по піларах/темах).
- Трекінг (07) пише: метрики у Posts, нові recycle-ідеї в Idea Pool (Source=recycle),
  оновлені пріори скорів.
