-- Initial schema: teas, brew sessions, infusions, comparisons, tasting notes

create table public.teas (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  tea_type      text not null check (tea_type in (
                  'green', 'white', 'yellow', 'oolong', 'black',
                  'sheng_puer', 'shou_puer', 'other_dark', 'herbal', 'flavoured_blend')),
  origin_region text,
  cultivar      text,
  harvest_year  int check (harvest_year between 1900 and 2100),
  season        text check (season in ('spring', 'summer', 'autumn', 'winter')),
  roast_level   text check (roast_level in ('none', 'light', 'medium', 'heavy')),
  vendor        text,
  url           text,
  notes         text,
  created_by    uuid references auth.users (id) on delete set null,
  created_at    timestamptz not null default now()
);

alter table public.teas enable row level security;

create table public.brew_sessions (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references auth.users (id) on delete cascade,
    tea_id      uuid not null references public.teas (id),
    brewed_at   timestamptz not null,
    method      text not null check (method in ('gongfu', 'western', 'grandpa', 'cold')),
    vessel      text,
    leaf_g      numeric check (leaf_g > 0),
    water_ml    numeric check (water_ml > 0),
    reaction    text check (reaction in ('liked', 'fine', 'disliked')),
    created_at  timestamptz not null default now()
);

alter table public.brew_sessions enable row level security;

create table public.infusions (
    id          uuid primary key default gen_random_uuid(),
    session_id  uuid not null references public.brew_sessions (id) on delete cascade,
    idx         int not null check (idx >= 1),
    temp_c      int check (temp_c between 0 and 100),
    steep_s     int check (steep_s >= 0),
    reaction    text check (reaction in ('liked', 'fine', 'disliked')),
    unique      (session_id, idx),
    unique      (id, session_id)
);

alter table public.infusions enable row level security;

create table public.comparisons (
    id          uuid primary key default gen_random_uuid(),
    user_id     uuid not null references auth.users (id) on delete cascade,
    tea_a_id    uuid not null references public.teas (id),
    tea_b_id    uuid not null references public.teas (id),
    outcome     text not null check (outcome in ('a', 'b', 'tie', 'skip')),
    reason      text,
    made_at     timestamptz not null default now(),
    check (tea_a_id <> tea_b_id)
);

alter table public.comparisons enable row level security;

create table public.tasting_notes (
    id          uuid primary key default gen_random_uuid(),
    session_id  uuid not null references public.brew_sessions (id) on delete cascade,
    infusion_id uuid,
    body        text not null,
    lang        text check (lang in ('en', 'zh', 'mixed')),
    created_at  timestamptz not null default now(),
    foreign key (infusion_id, session_id)
        references public.infusions (id, session_id) on delete cascade
);

alter table public.tasting_notes enable row level security;

create index on public.brew_sessions (user_id);
create index on public.brew_sessions (tea_id);
create index on public.comparisons (user_id);
create index on public.comparisons (tea_a_id);
create index on public.comparisons (tea_b_id);
create index on public.tasting_notes (session_id);
create index on public.tasting_notes (infusion_id);
create index on public.teas (created_by);

