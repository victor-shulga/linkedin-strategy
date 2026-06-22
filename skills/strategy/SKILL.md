---
name: strategy
description: Build a machine-readable LinkedIn social selling strategy in Notion from a person LinkedIn profile + company site/LinkedIn — goals/KPI, ICP+persona, enemy+signature, content pillars (no quotas), offer audit for LinkedIn sellability, voice profile, viral levers, distribution playbook, backstory. Use when starting LinkedIn content for a new client, or when the user asks to build a LinkedIn strategy, контент-стратегію, or voice profile for a person.
argument-hint: "<person-linkedin-url> <company-site-or-linkedin>"
---

# Strategy — LinkedIn-стратегія як конфіг

Standalone-тул: створює стратегічний документ у Notion за каноном
`${CLAUDE_PLUGIN_ROOT}/reference/strategy-template.md` (9 секцій). Це не PDF для клієнта,
а **конфіг для всіх наступних кроків контент-движка** (research, тижневий план, продакшн):
секції 4, 6, 7 — машиночитні таблиці.

**Вхід:** `$ARGUMENTS` — LinkedIn-профіль людини + сайт або company-LinkedIn. Якщо чогось
бракує — запитай перед стартом.

## Збір даних

1. **Профіль людини (Apify):** `apimaestro/linkedin-profile-detail` (хедлайн, about, досвід) +
   `apimaestro/linkedin-profile-posts` (останні 50–100 постів). З постів витягни:
   - реальні мовні патерни автора (для Секції 6 — voice profile);
   - що вже працювало: топ-пости по engagement (пріори для Секцій 4 і 7);
   - біографічні факти-«патрони» з числами (для Секції 9).
   Якщо постів нема/мало — позначи «холодний акаунт», voice profile буде [ПРИПУЩЕННЯ]
   з калібруванням на перших 10 постах.
2. **Компанія:** сайт — через скіли `website-scraper` + `deep-company-analyser` (фолбек:
   WebFetch по ключових сторінках; SPA-фолбек: Apify `apify/website-content-crawler`).
   Company-LinkedIn — `scrapemint/linkedin-company-employees-scraper` (headcount, ролі).
3. **Документи клієнта:** запитай ICP-док і value prop. Є — то першоджерело для Секцій 2, 5.
   Нема — будуй припущення зі скрейпу і познач кожне **[ПРИПУЩЕННЯ]**.
4. **Реюз GTM-стратегії:** якщо клієнт є в Notion-базі «GTM Strategy» (плагін gtm-strategy) —
   Секції 2, 3, 5 адаптуй звідти, не дублюй роботу.
5. **Секція 5 — офер-аудит:** інвентаризація → скоринг LinkedIn-продажності (4 осі × 8 критеріїв
   з `strategy-template.md`) → гап-мапа драбини → рекомендації нових оферів [ПРИПУЩЕННЯ].
   Якщо драбини оферів нема — спершу виклич скіл `offer-ladder`, потім накладай скоринг.

## Побудова документа

Заповни всі 9 секцій за `strategy-template.md`, з правилами:

- **Секція 4 (пілари):** 3–5 піларів; кожен прив'язаний до viral lever
  (`${CLAUDE_PLUGIN_ROOT}/reference/methodology.md` §5) і до доказів компетенції, знайдених
  у п.1. БЕЗ жорстких квот — тільки funnel + день тижня; баланс тримає тижневий планувальник.
  Якщо у клієнта мало доказів — пілари на запасних стратегіях компетенції (methodology §2.3).
- **Ритм у Секції 4:** базуйся на methodology §2.5, але підлаштуй під commitment
  (3 пости/тиждень → Пн/Ср/Пт: TOFU-MOFU-BOFU-ротація; 4 → без другого TOFU).
  Формати не фіксуй — їх визначить тестування.
- **Секція 6 (voice):** список «що ніколи не пишемо» — мінімум 5 пунктів, з них
  частина універсальні (AI-кліше), частина — специфічні для людини (з аналізу постів).
- Хуки-приклади в піларах — за правилами `${CLAUDE_PLUGIN_ROOT}/reference/hook-bank.md`.

## Вихід (Notion)

1. Якщо нема головної сторінки «Content Engine» — створи її + DB Idea Pool / Weekly Plans /
   Posts за `${CLAUDE_PLUGIN_ROOT}/reference/notion-schema.md`. Повідом користувачу ID
   для збереження в пам'ять.
2. Створи/онови сторінку **«🧭 {Client} · Strategy»** з 9 секціями.
3. В кінці документа — блок **«Відкриті питання»**: всі [ПРИПУЩЕННЯ] списком з питанням
   до клієнта на кожне.
4. Засій Idea Pool: 10–15 стартових ідей (по 2–3 на пілар) зі статусом `new`,
   Source = `matrix-expansion`, кожна з hook draft і competence proof.

## Definition of Done

- Всі 9 секцій заповнені; жодного «TBD» без позначки [ПРИПУЩЕННЯ].
- Секції 4, 6, 7 — таблицями (машиночитні).
- Voice profile містить ≥ 3 фірмові патерни з реальних постів (або позначений холодний акаунт).
- Пілари без квот: тільки funnel + день; ритм покриває commitment (N постів/тиждень).
- Idea Pool засіяний ≥ 10 ідеями, кожна проходить гейт competence proof.
- Блок «Відкриті питання» сформований; короткий summary повернуто користувачу.
