# Mobo App — UI Style Guide

Default UI reference for any Mobo app. Unless the user explicitly asks for a different
look, all new or modified UI (screens, widgets, dashboards, forms, lists) follows the specs
below. This file is meant to be copied as-is into every new Mobo project (a new app is
normally created from the standard template: splash → login → home/dashboard → profile,
then customized per module) — nothing in it should be specific to any one app's module or file layout beyond §0.

---

## 0. Setup Check (run once per project, right after copying this file in)

1. Locate the project's theme/color file (usually `lib/core/theme/app_theme.dart` or
   `lib/core/colors/app_colors.dart`).
2. Compare its color constants against the **Color Palette** table in §1.
3. Add any token that's missing directly to that file (as a `static const Color`, plus a
   `StatusColors` class for the semantic/status table if one doesn't already exist).
4. Replace the line below with the result.

**Palette status:** ✅ Connected — `lib/utils/app_theme.dart` is the source of truth:
`AppTheme` (palette §1, form-field helpers `fieldDecoration` / `fieldValueStyle` /
`fieldHintStyle` / `fieldLabelStyle`, and `ThemeData`), `StatusColors` (semantic/status map
§1 as `statusGreen`/`statusBlue`/… + `buildStatusBadge` §10), `AppShadows` (§3) and
`AppRadius` (§4).

Shared form building blocks live in `lib/global_methods/widgets/forms/`: `MoboFormCard`
(§8 section card), `FieldLabel` / `LabeledField` (§2/§6 labels), `MoboSubmitButton` (§5),
`MoboDropdownOptionTile` and `MoboDropdownStyles` (§7). The shared fields in
`lib/global_methods/widgets/textfields/`, `drop_downs/` and `date_picker/` are built on them.

Legacy colour holders still exist — `AppStyle` (`lib/utils/globals.dart`) and two
`AppColors` classes (`lib/global_methods/const.dart`, `lib/core/colors/app_colors.dart`);
prefer the tokens above in new or touched code.

---

## 1. Color Palette

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#C03355` | Brand color — AppBar, primary buttons, links, selected states, icons |
| `secondary` | `#FFFFFF` | Secondary/contrast color |
| `dark` | `#101010` | Primary text (light mode) |
| `white` | `#FFFFFF` | Surfaces (light mode) |
| `lightGrey` / `background` | `#F3F3F3` | Generic light background |
| `scaffoldBackground` | `#FAFAFA` | Scaffold background (light theme) |
| `textPrimary` | `#101010` | Primary text |
| `textSecondary` | `#666666` | Secondary/meta text |
| `divider` | `#E0E0E0` | Hairlines |
| `shadow` (constant) | `#000000` @ ~10% (`0x1A000000`) | Reference shadow color constant |
| Dark scaffold | `#181A20` | Scaffold background (dark theme) |
| Dark surface | `#1E1E1E` / `Colors.grey[850]` | Card/sheet/dialog surfaces (dark) |

**Status/semantic colors** (`StatusColors`) — use these for every status/stage indicator
instead of inventing new ones:

| Status | Hex | Meaning |
|---|---|---|
| Green | `#00A63E` | approved, done, posted, won, paid, planned |
| Blue | `#3B82F6` | sent, qualified, in-progress/proposal |
| Orange | `#F97316` | draft |
| Red | `#EF4444` | cancelled, lost |
| Teal | `#14B8A6` | locked/done (secondary "complete" state) |
| Grey | `#6B7280` | unknown/default fallback |

Icon/background tint pairs also exist per-semantic (info/success/warning/error), each with
an `xIcon` (pastel), `xIconBackground` (12–20% alpha), and `xBackgroundDark/Light` variant
— replicate this pattern for tinted icon chips in info/success/warning/error states (§16).

Never use raw Material colors (`Colors.blue`, `Colors.green`, etc.) directly in a widget —
always go through the semantic tokens above.

---

## 2. Typography

Font family app-wide: **Google Fonts "Manrope"**, set once on `ThemeData`.

| Role | Size | Weight | Color |
|---|---|---|---|
| Dialog / section title | 18–20 | `bold` | `primary` or dark text |
| Card / list title (name) | 15–18 | `w600`/`bold` | `primary` |
| Card body / value text | 14 | `w600` | dark (light) / white (dark) |
| Field label | 16 | `bold` if emphasized, else `normal` | dark; required marker = red bold `" *"` |
| Secondary label (e.g. "Due Date") | 13–14 | `w500`/`normal` | `grey[600]` light / `grey[400]` dark |
| Meta / caption text | 12 | `normal`/`bold` | grey |
| Status badge text | 11 | `w600` | badge color (light) / white (dark), `letterSpacing: 0.1` |
| Empty-state title | 18–20 | `bold` | dark / `#1A1A1A` |
| Empty-state subtitle | 14 | `normal` | `black54`/`white60` |
| Error screen title | 22 | `bold` | dark/`grey.shade800` |
| Error screen body | 16 | `normal` | `grey[400]`/`grey.shade600` |

Rule of thumb: **title = bold + larger + brand-or-dark color, subtitle/label = medium + smaller + grey.**

---

## 3. Elevation & Shadow Tokens

Flat by convention: `elevation: 0` / `shadowColor: transparent` on buttons, AppBar, FABs,
and dialogs. Depth comes only from explicit `BoxShadow` on `Container`s, never from
Material `elevation`.

```dart
/// Standard "flat card" shadow — list items, list-style cards, form cards.
static const cardShadow = BoxShadow(
  color: Color(0x0D000000), // black @ 5%
  offset: Offset(0, 6),
  blurRadius: 16,
  spreadRadius: 2,
);

/// "Panel" shadow — bigger surfaces like chart containers, dashboard sections.
static BoxShadow panelShadow(bool isDark) => BoxShadow(
  color: isDark ? Colors.black26 : Colors.black.withOpacity(0.08),
  blurRadius: 12,
  offset: const Offset(0, 4),
);

/// Soft shadow for pill-shaped search bars only.
static const searchShadow = BoxShadow(
  color: Color(0x0A000000), // black @ 4%
  offset: Offset(3, 11),
  blurRadius: 8.5,
  spreadRadius: -3,
);
```

`cardShadow` → essentially every card/list-tile. `panelShadow` → larger dashboard/section
containers. Kanban tiles are the one component that uses a **border instead of a shadow** (§11).

---

## 4. Spacing & Radius Scale

| Radius | Used for |
|---|---|
| `4` | small chip corner, tiny inner accents |
| `5` | compact/status dropdown ("pill-like" form-view dropdown), icon-button container |
| `6` | small tab/segment chip |
| `8` | dropdown/filter control, popup menus, inner input border (legacy) |
| `10` | segmented view-selector control, quantity/numeric field variant |
| `12` | **default radius** — cards, list tiles, buttons, text fields, tag chips, status badge (alt formula) |
| `16` | kanban column, bottom sheet (top corners), panel/section container, some dialogs, grouped section header |
| `18` | canonical status badge (`StatusColors.buildStatusBadge`) |
| `20` | pill buttons/chips, multi-select chip, global dialog theme radius, pagination counter pill, active-filters pill |
| `28` | tall/full bottom sheet variant (rare) |

Spacing: `4 / 6 / 8 / 10 / 12 / 14 / 16 / 20` px are the recurring gaps. Card outer
`margin: EdgeInsets.only(bottom: 12)`, card inner `padding: EdgeInsets.all(14)` are the
default for list-style cards.

**Default radius when unsure: `12`.**

---

## 5. Buttons

**Primary button** — filled, brand color, always paired with a fixed height wrapper:

```dart
SizedBox(
  height: 48,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: isLoading ? null : onPressed,
    child: isLoading
        ? const SizedBox(
            width: 24, height: 24,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
        : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  ),
)
```

**Outlined (secondary) button** — Cancel/dismiss actions, same height & radius:

```dart
OutlinedButton.styleFrom(
  foregroundColor: AppTheme.primaryColor,
  side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  padding: const EdgeInsets.symmetric(vertical: 12),
)
```

**Pill/chip button** (e.g. quick filter, tertiary action): `BorderRadius.circular(20)`,
`padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5)`, background
`Colors.grey.shade200`, text `fontWeight: w500`.

**Disabled state**: background `grey[700]`(dark)/`grey[300]`(light),
foreground `grey[400]`(dark)/`grey[500]`(light).

**Two-button footer convention** (dialogs & bottom sheets): `Row` of two `Expanded`
buttons, `SizedBox(width: 12)` gap, left = Outlined ("Cancel"/"Clear All"), right = filled
("Save"/"Apply"), both `height: 48`, `radius: 12`.

**Icon-only square button** (rare): `50×50`, `padding: 10`, `radius: 5`, icon size `30`,
pastel tinted background.

Buttons never carry a `BoxShadow`.

---

## 6. Text Fields

**Standard field** — filled container + transparent border, error state turns the border red:

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: isDark ? Colors.grey[850] : const Color(0xFFF2F4F6),
    border: Border.all(
      color: hasError ? Colors.red : Colors.transparent,
      width: 1,
    ),
  ),
  child: TextField(
    decoration: InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
    ),
    style: TextStyle(
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : Colors.black87,
    ),
  ),
)
```

- **Label** above the field: `fontSize: 16`, bold if emphasized; required marker = red bold `" *"` suffix.
- **Error text**: custom `Text` below the field (`color: Colors.red, fontSize: 12`,
  `padding: EdgeInsets.only(top: 4, left: 4)`) — not the built-in `errorText`.
- Focus ring: `OutlineInputBorder(borderRadius: BorderRadius.circular(12))`,
  focused: same radius, `BorderSide(color: primary, width: 2)`.

**Search field** — visually distinct, card-like, no border, its own soft shadow:

```dart
Container(
  height: 40,
  decoration: BoxDecoration(
    color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [AppShadows.searchShadow], // see §3
  ),
  child: TextField(
    decoration: const InputDecoration(
      border: InputBorder.none,
      prefixIcon: Icon(Icons.search_rounded, size: 20, color: Colors.grey),
      hintText: 'Search by name',
      hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    ),
  ),
)
```
Show a `clear` (`Icons.clear_rounded`, size 18) suffix only when the field is non-empty.
A separate `40×40` filter icon button with the same radius/shadow sits next to it when a
filter action is needed.

**Quantity / numeric field** (product quantity in a cart, order line, or stock count) — a
plain numeric field with a label above it, not a +/− stepper:

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Quantity', style: TextStyle(
      color: isDark ? Colors.white60 : Colors.black54,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    )),
    const SizedBox(height: 10),
    TextFormField(
      controller: qtyController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: 'Quantity',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : const Color(0xFFF2F4F6),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ],
)
```
Default to `"0.0"` `onTapOutside` if left empty rather than leaving it blank. Use this same
pattern for any quantity-entry field (adjustment quantity, replenishment order-point value,
transfer line quantity).

---

## 7. Dropdowns & Select Fields

**Default single-select / searchable dropdown** (`dropdown_search` package): same filled
container styling as text fields (radius 12, `#F2F4F6`/`grey[850]` fill, transparent
border, focused border `primary` width 1.5–2).
- Popup menu: `RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))`,
  `elevation: 4`, `constraints: BoxConstraints(maxHeight: 320)`.
- Popup search box: filled `#F3F4F6`/`grey[850]`, `prefixIcon: Icons.search`, radius 10 (closed) / 8 (focused).
- Selected item text: `fontWeight: w600, fontSize: 16`; unselected list item text: `w400`.

**Multi-select field**: same container, but visible `grey[300]`/`grey[700]` 1px border when
not focused. Selected values render as pill chips:

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: const Color(0xFFFCE7EE),                      // pale primary tint
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: primary.withOpacity(0.35), width: 1),
  ),
  child: Row(mainAxisSize: MainAxisSize.min, children: [
    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: primary)),
    const SizedBox(width: 4),
    Icon(Icons.close, size: 14, color: primary),
  ]),
)
```
Overflow beyond visible chips: `'+N more'` chip, `grey[200]` bg, `grey[700]` text, same pill radius.
Multi-select popup: header with bottom border + "Done" text button (`primary`, `w600`),
checkbox items use a **square** checkbox (`radius 4`, `primary` fill when checked, 1.5px
`primary` border when unchecked) rather than the native round Material checkbox.

**Compact/status dropdown** (e.g. stage selector inline in a row): smaller, pill-ish,
`radius: 5`, `closedSuffixIcon: Icons.keyboard_arrow_down_sharp` colored `primary`, header
text `primary` + bold. Use this only for compact inline pickers, not full-width form fields.

**Group-by / filter dropdown** (sits above a list/kanban view):

```dart
Container(
  height: 38,
  padding: const EdgeInsets.symmetric(horizontal: 8),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: hintBorderColor),
    color: isEnabled ? Colors.white : Colors.grey[100],
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<T>(
      icon: Icon(Icons.group_work, size: 18, color: isEnabled ? primary : Colors.grey),
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ...
    ),
  ),
)
```

**Segmented view-selector** (Graph/Pivot/List-style toggle):
`constraints: BoxConstraints(minHeight: 35)`, `padding: EdgeInsets.symmetric(horizontal: 8-12, vertical: 6)`,
`radius: 10`, background `grey[100]`/`grey[800]`, `border: 1px grey[300]/grey[700]`, active
segment inverts to a filled state.

---

## 8. Cards & List Items

The single most-reused pattern — the **canonical "flat card"**:

```dart
InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(12),
  child: Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? Colors.grey[850]! : Colors.grey[200]!,
        width: 0.5,
      ),
      boxShadow: const [AppShadows.cardShadow], // see §3
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: /* title / subtitle / trailing */,
    ),
  ),
)
```

- Build cards with `InkWell` + `Container`, not the stock `ListTile` — full control over
  title/subtitle/badge/trailing layout.
- Title: `fontSize: 15–18, fontWeight: w600/bold, color: primary`.
- Subtitle rows: `fontSize: 13, color: black54/white60`.
- Trailing: a status badge (§10) and/or a row-action `PopupMenuButton` (§9) — no
  swipe-to-delete; deletion goes through a popup menu + confirmation dialog.
- No `Divider` between cards — separation is via the `12px` bottom margin, not hairlines.
- Bigger "panel" containers (chart/dashboard sections) use `radius: 16` and `panelShadow`
  instead of the list-item recipe.

---

## 9. Row Actions — PopupMenuButton

App-wide popup menu theme:

```dart
popupMenuTheme: const PopupMenuThemeData(
  color: Colors.white,                 // dark theme: Color(0xFF2C2C2E)
  surfaceTintColor: Colors.transparent,
  elevation: 4,
),
```

Trigger icon on a card or detail screen — `Icons.more_vert`, sized to match its context
(`20` on a list-card trailing action, `22–24` in an AppBar), colored to match the
surrounding icon/text color (`white`/`black` per theme), typically with `position:
PopupMenuPosition.under` so the menu drops directly beneath the trigger:

```dart
PopupMenuButton<String>(
  position: PopupMenuPosition.under,
  icon: Icon(Icons.more_vert, color: isDark ? Colors.white : Colors.black),
  onSelected: (value) { /* handle action */ },
  itemBuilder: (context) {
    final itemTextColor = isDark ? Colors.white : Colors.black87;
    return [
      PopupMenuItem<String>(value: 'edit', child: Text('Edit', style: TextStyle(color: itemTextColor))),
      PopupMenuItem<String>(value: 'delete', child: Text('Delete', style: TextStyle(color: itemTextColor))),
    ];
  },
)
```

Menu items are **plain text, no leading icons, no custom padding** — let the global
`popupMenuTheme` do the rest. This is the standard way to expose row-level actions
(edit / delete / duplicate) instead of swipe gestures.

---

## 10. Status Badges & Tags

Two distinct components — don't merge them:

**Status badge** (order/quotation/transfer state) — canonical formula:

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: isDark ? Colors.white.withOpacity(0.15) : statusColor.withOpacity(0.12),
    borderRadius: BorderRadius.circular(18),
  ),
  child: Text(
    label,
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : statusColor,
      letterSpacing: 0.1,
    ),
  ),
)
```
No border. Color comes from the `StatusColors` semantic map (§1).

**Tag chip** (categorization, non-status labels):

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: const Color(0xFFFCE7EE),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: primary.withOpacity(0.35), width: 1),
  ),
  child: Text(tag, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: primary)),
)
```
Use `Wrap(spacing: 6, runSpacing: 6)` when laying out multiple tags.

---

## 11. Kanban Board

`drag_and_drop_lists` package.

- **Column width**: `~304–320px`.
- **Column header**: `padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)`,
  `color: white/grey[850]`, `borderRadius: BorderRadius.vertical(top: Radius.circular(16))`.
- **Column count pill** inside the header: black background, `radius: 20`,
  `padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4)`, white text `14/w600`.
- **Column body**: same fill color, `borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))`
  — header + body together read as one 16px-rounded column.
- **Card inside a column** — **border-only, no shadow** (so cards don't visually compete
  inside a column):
  ```dart
  Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!, width: 1),
    ),
  )
  ```
- Small circular avatar inside a card: `22×22`, `ClipRRect(circular(11))` inside a 1.5px
  bordered circle; text-initial fallback uses a hashed color from a fixed avatar palette.
- No explicit drag handle icon — the whole tile is draggable via long-press (package default).
- "Add stage" affordance (if end-users can add columns): same 16px-rounded column shell with
  an inner black pill button (`radius 8`, `padding h12/v8`, `Icons.add` size 16 + white bold text).

---

## 12. Grouped Section Header (GroupByHeader)

Use rarely — for a collapsible section header above a *grouped* list/kanban section, not
as the default list/kanban heading (the plain group-by dropdown in §7 covers most cases):

```dart
Container(
  margin: const EdgeInsets.only(bottom: 8),
  decoration: BoxDecoration(
    color: isDark ? Colors.grey[850] : Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
    ),
    boxShadow: [
      BoxShadow(
        blurRadius: 16,
        spreadRadius: 2,
        offset: const Offset(0, 6),
        color: Colors.black.withOpacity(0.08),
      ),
    ],
  ),
  child: InkWell(
    onTap: onToggle,
    borderRadius: BorderRadius.circular(8),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(groupName, style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
                const SizedBox(height: 4),
                Text('$itemCount items', style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                )),
              ],
            ),
          ),
          // Optional summary badge (e.g. total value) via §10's status-badge formula, statusGreen.
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ],
      ),
    ),
  ),
)
```
Container reuses the `cardShadow`-family recipe (§3) at `radius 16` — a 12px `InkWell`
ripple inside a 16px shell.

---

## 13. Bottom Navigation Bar

`flutter_snake_navigationbar` — an animated "snake" indicator that slides beneath the
selected tab.

```dart
SnakeNavigationBar.color(
  behaviour: SnakeBarBehaviour.pinned,
  snakeShape: SnakeShape.indicator,
  padding: EdgeInsets.zero,
  height: 70,
  elevation: 8,
  backgroundColor: isDark ? Colors.grey[900] : Colors.white,
  shadowColor: isDark ? Colors.black26 : Colors.grey[200]!,
  snakeViewColor: colorScheme.primary,
  selectedItemColor: isDark ? Colors.white : colorScheme.primary,
  unselectedItemColor: isDark ? Colors.grey[400] : Colors.black,
  showSelectedLabels: true,
  showUnselectedLabels: true,
  selectedLabelStyle: TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: isDark ? Colors.white : colorScheme.primary,
  ),
  unselectedLabelStyle: TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: isDark ? Colors.grey[400] : Colors.grey[600],
  ),
  items: [/* BottomNavigationBarItem per tab, icon wrapped in
             Padding(vertical: 5), activeIcon recolored to primary/white */],
)
```

- Fixed **height: 70**, **elevation: 8** (the one navigation element allowed a real elevation/shadow).
- Selected label is one step larger and bolder than unselected (`12/w600` vs `11/w500`).
- Icon set: HugeIcons where available, Material icons as fallback for tabs without a
  matching HugeIcon.

---

## 14. Pagination Controls

For any paged list/table view (product lists, move history, reports):

```dart
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!, width: 1),
      ),
      child: Text(paginationText, style: TextStyle(
        color: isDark ? Colors.white70 : Colors.black87,
        fontSize: 13,
      )),
    ),
    // Prev/next arrows: 32×36 tap targets, CircleBorder ripple,
    // arrow icons size 20, active color black87/white, disabled color grey400/600.
  ],
)
```
- Counter pill: `height: 36`, `radius: 20`, bordered, text `13px`.
- Arrow buttons: `32×36`, circular ripple, `size: 20` icons, dim to `grey[400]`/`grey[600]`
  when disabled rather than hiding (unless the toolbar is compact enough to warrant hiding
  a disabled arrow entirely).

---

## 15. Loading / Shimmer Skeletons

`shimmer` package. Match the skeleton's shape/radius to the real component:

- List-tile shimmer: `baseColor: Colors.grey[300], highlightColor: Colors.grey[100]`.
- Card/kanban shimmer: `baseColor: Colors.grey[200], highlightColor: Colors.grey[50]`.
- Skeleton bar radii: `4` for text lines, `6` for title-sized bars, `8`/`12` for
  icon/badge placeholders, `16` for card placeholders, full circle for avatars.
- Card-shaped skeletons carry the *same* `cardShadow`/border as the real card so loading
  and loaded states don't visually jump.
- Default shimmer `period` (~1500ms) — don't override.
- On a colored surface (e.g. the primary-color greeting card, §17), shimmer with
  `Colors.white.withOpacity(0.2–0.3)` base / `0.4–0.6` highlight instead of the grey pair.

---

## 16. Icon Containers & Avatars

- **Tinted icon circle** (e.g. activity-type icon): `46×46`, `shape: BoxShape.circle`,
  `color: semanticColor.withOpacity(0.1)`, icon `size: 22`, `color: semanticColor`.
- **Solid action badge** (e.g. edit/camera overlay on an avatar): `36×36` circle, solid
  `primary` fill, white 3px border, `Icons.*` size 18, white icon.
- **Profile avatar placeholder**: large `120×120` (or `90×90` compact) circle,
  `color: grey[700]/grey[300]` fill when no image.
- **Small tab/segment icon container**: `padding: 8`, `radius: 6`, `1px` grey border,
  icon size `18`; selected state flips to a solid black/white background with inverted icon color.

Never use a two-color gradient for icon containers or cards — keep all fills flat.

---

## 17. Dashboard Layout

- Stat tile = the canonical card recipe (§8) at `radius 12` with `cardShadow`, or `radius 16`
  + `panelShadow` if it's a larger section-level tile.
- Value text: bold, large (≥ 20), `primary` or dark. Label/caption beneath: `grey[600]`, `12–14px`, `w500`.
- Icon inside a stat tile: the tinted icon-circle pattern from §16, not a raw icon.
- Layout: a `GridView`/`Wrap` of these cards; horizontal/vertical gap between tiles = `12`.
- Section/page header above dashboard content: `fontSize: 18, fontWeight: bold, color: primary`.
- Gap between a control row (filters/toggles) and content below it: `SizedBox(height: 10-12)`.
- Loading state: shimmer-skeleton the tiles (§15), not a spinner.

**Dashboard greeting card** — hero banner:

```dart
Container(
  margin: const EdgeInsets.all(16),
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: theme.primaryColor,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greetingText, style: const TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700,
              letterSpacing: 0.1, height: 1.2,
            )),
            const SizedBox(height: 8),
            Text(subtitleText, style: TextStyle(
              color: isOffline ? Colors.orange[200] : Colors.white.withOpacity(0.9),
              fontSize: 13, fontWeight: FontWeight.w400, height: 1.3,
            )),
          ],
        ),
      ),
      const SizedBox(width: 16),
      Container(
        width: 56, height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        ),
        child: OdooAvatar(/* size: 52, iconSize: 28, borderRadius: circular(26) */),
      ),
    ],
  ),
)
```
- Greeting text switches on time of day ("Good Morning/Afternoon/Evening") + first name.
- Subtitle swaps to an offline notice (`Colors.orange[200]`) when connectivity drops.
- Font sizes (`19`/`13`) may scale slightly with screen width (`clamp(0.85, 1.2)` against a
  390px baseline).
- Loading state: `Shimmer.fromColors` with the white opacity pairs from §15.

---

## 18. Active Filters Badge

Sits on a filter bar next to a group-by control. In this app it is the shared
`ActiveFiltersBadge(count:)` (`lib/global_methods/widgets/active_filters_badge.dart`) — use it
rather than building the pill by hand:

```dart
count == 0
  ? Text('No filters applied', style: TextStyle(
      fontSize: 12,
      color: isDark ? Colors.white70 : theme.colorScheme.onSurface.withOpacity(0.7),
      fontWeight: FontWeight.w500,
    ))
  : Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.grey[700]!) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count', style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white,
          )),
          const SizedBox(width: 5),
          const Text('Active', style: TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    )
```
- Solid black with white text, matching the black group-by pill beside it. In dark mode it
  gets a `grey[700]` 1px border so it doesn't disappear against the dark scaffold.
- Hide entirely (`SizedBox.shrink()`) when `count == 0` **and** a group-by pill is already
  showing on the same row.

---

## 19. Dialogs & Bottom Sheets

**Dialogs**: fully rounded on all corners, `radius: 20`, `elevation: 0`,
`shadowColor: transparent`, background white/`#1E1E1E`. A tighter `radius: 16` variant is
reserved for compact action dialogs (confirm/delete) — no other one-off radii.
- Title bar: `padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16)`, `fontSize: 18, fontWeight: bold/w600`,
  trailing `IconButton(icon: Icons.close)`.
- Footer buttons follow the two-button convention from §5.

**Bottom sheets**: top-rounded only, `BorderRadius.vertical(top: Radius.circular(16))`
(`28` only for a rare full-height variant), background `grey[50]`/`#1E1E1E`,
`backgroundColor: Colors.transparent` on `showModalBottomSheet` itself (the inner
`Container` supplies the real background + radius).
- Drag handle: centered `40×4` bar, `radius: 2`, `grey[300]`/`grey[700]`, `padding: EdgeInsets.only(top: 12, bottom: 8)`.
- Header/footer/button conventions match dialogs above.
- Top-rounded-only is the visual differentiator between a bottom sheet and a dialog — never
  round all four corners on a sheet.

---

## 20. Empty & Error States — Module Not Installed / Missing

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Animated icon medallion
    Container(
      width: 120, height: 120,
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(Icons.extension_off_rounded, size: 60, color: Colors.orange.shade700),
    ), // wrap in TweenAnimationBuilder(scale 0→1, 600ms) for the entrance pop
    const SizedBox(height: 32),
    Text('Module Not Installed', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
    const SizedBox(height: 16),
    // Module-name pill
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.inventory_2_outlined, size: 18, color: Colors.orange.shade700),
        const SizedBox(width: 8),
        Text(moduleName, style: theme.textTheme.titleSmall?.copyWith(color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
      ]),
    ),
    const SizedBox(height: 24),
    // Message card — reuses the app's card radius(16) + soft shadow, tinted orange border
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.2), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        Text(message, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        // Info sub-banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
            const SizedBox(width: 12),
            Expanded(child: Text(hint, style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue.shade700, height: 1.4))),
          ]),
        ),
      ]),
    ),
    const SizedBox(height: 32),
    // Actions: Wrap(spacing:12, runSpacing:12) of Retry (Outlined) + Contact Admin (filled, orange.shade700)
  ],
)
```
- Semantic color is **orange** for "module not installed"; a plain "something went wrong"
  error reuses the same layout skeleton in **red**.
- Buttons: `OutlinedButton.icon` (Retry) + `ElevatedButton.icon` (Contact Admin,
  orange-filled), `padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14)` — larger
  than the standard §5 padding because this is a full-screen empty state, not an inline action.
- Typography follows §2 (title 18–20/bold, body 14–16/normal, grey).

---

## 21. Animation

- `AnimatedContainer(duration: Duration(milliseconds: 250), curve: Curves.easeInOut)` for
  small state-driven style changes (badge color/size change, toggle chip selection).
- Page transitions: `FadeTransition`/slide transitions, not the default Material push.
- Content swap within a screen (e.g. error message appearing): `AnimatedSwitcher`.
- Loading states: shimmer skeletons (§15), not bare spinners.
- A one-off entrance animation (e.g. §20's icon scale-in) can use `TweenAnimationBuilder` —
  keep it short (~600ms) and reserve it for a screen's single hero element.
- Transitions stay subtle and short — ≤ 300ms for micro-interactions.
