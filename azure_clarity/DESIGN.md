# Azure Clarity Design System

### 1. Overview & Creative North Star
**Creative North Star: The Urban Concierge**
Azure Clarity is built for streamlined efficiency within high-density environments. It rejects the "industrial" look of property management in favor of a clean, editorial aesthetic that feels more like a lifestyle app than a database. The system utilizes a "Bright-Canvas" approach: high-contrast typography, generous negative space, and a primary blue that serves as a beacon of action amidst a sea of calm neutrals.

### 2. Colors
The palette is dominated by `Surface` (f6f7f8) and `White` (ffffff), creating a layered, breathable interface.
- **The "No-Line" Rule:** Explicitly prohibit 1px solid borders for primary sectioning. Card boundaries and section changes are defined by the transition from `Surface` to `Surface Bright` (White).
- **Surface Hierarchy:** 
    - Base Level: `Surface` (#f6f7f8)
    - Card Level: `Surface Bright` (#ffffff)
    - Active State: `Primary Container` (#d1eefc)
- **Signature Accent:** The Primary Azure (#19a1e6) is used exclusively for actionable text and critical branding, while Emerald (#10b981) provides a semantic cue for "Active/Healthy" statuses.

### 3. Typography
Azure Clarity uses **Manrope** across all levels to maintain a modern, geometric consistency. The hierarchy is driven by weight rather than just size.
- **Display/Headline:** 1.5rem (24px) / 1.25rem (20px). Semi-Bold/Bold. Used for screen titles and room identifiers to create immediate focal points.
- **Body Content:** 1rem (16px) for standard text. Used for primary names and user data.
- **Utility/Labels:** 0.875rem (14px) and 0.75rem (12px). Used for status badges, phone numbers, and filter chips.
- **The Rhythmic Scale:** The system leans on the 4px grid. A tight tracking-tight on headlines ensures the "Editorial" feel, making the bold text feel like a masthead rather than a label.

### 4. Elevation & Depth
Depth is achieved through **Tonal Layering** rather than heavy shadows.
- **The Layering Principle:** Content cards must always be `Surface Bright` set against a `Surface` background. This "paper-on-desk" stacking provides natural hierarchy.
- **Ambient Shadows:** The system uses a singular `shadow-sm` (0 1px 2px 0 rgba(0, 0, 0, 0.05)). It is almost imperceptible, serving only to separate the card from the background when the user scrolls.
- **Glassmorphism:** The sticky header and bottom navigation utilize a high-opacity background blur to maintain context while ensuring legibility.

### 5. Components
- **Buttons & Chips:** Use fully rounded (pill-shaped) geometry for filters. Active states use `Primary` with white text; inactive states use `Secondary Container` with `Secondary` text.
- **Cards:** Cards feature `xl` (12px) border radius. They should never have borders. Internal spacing is set to a rigid 16px (p-4).
- **Input Fields:** Search bars should be integrated into the layout using `Surface Container` (Slate-200) rather than outlined boxes, minimizing visual noise.
- **Status Badges:** Small, rectangular with moderate rounding (`md`). They must include both a color-coded dot and text for accessibility.

### 6. Do's and Don'ts
**Do:**
- Use bold primary colors for titles to guide the eye.
- Use `slate-500` for secondary metadata to create clear information hierarchy.
- Embrace whitespace; allow cards to "breathe" with 12px gaps (`gap-3`).

**Don't:**
- Do not use 1px borders to separate list items; use padding and background shifts.
- Do not use "pure black" (#000). Use `Slate-900` (#0f172a) for high-contrast text.
- Do not use sharp corners. The system requires a minimum of 4px (`DEFAULT`) and prefers 12px (`xl`) for main containers.