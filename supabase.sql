-- 지하네 은하수 과일가게 - Supabase 준비용 SQL
-- 2026-10-10 에 이미 실행해 두었습니다. (프로젝트 kangmvsmvdkrnqvjtcda)
-- 나중에 다른 프로젝트에 다시 붙일 때 이 파일을 SQL Editor 에 붙여넣고 Run 하세요.

-- 1) 주문을 담아 둘 표
create table if not exists public.orders (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  user_id     uuid references auth.users (id),  -- 로그인하고 주문하면 누가 샀는지 남습니다
  items       jsonb   not null,                 -- 담은 품목 [{name, price, count}, ...]
  goods_total integer not null,                 -- 상품금액
  ship_fee    integer not null,                 -- 배송비
  total       integer not null                  -- 총 결제금액
);

-- 2) 보안(RLS)을 켭니다. 켜 두지 않으면 누구나 전체 주문을 볼 수 있습니다.
alter table public.orders enable row level security;

-- 3) 주문은 누구나 넣을 수 있게 합니다 (로그인하지 않은 손님도 주문 가능)
drop policy if exists orders_insert_anyone on public.orders;
create policy orders_insert_anyone
  on public.orders
  for insert
  to anon, authenticated
  with check (true);

-- 4) 읽기는 로그인한 사람이 자기 주문만 볼 수 있게 합니다.
--    가게 주인은 Supabase 대시보드 > Table Editor 에서 전체 주문을 볼 수 있습니다.
drop policy if exists orders_select_own on public.orders;
create policy orders_select_own
  on public.orders
  for select
  to authenticated
  using (auth.uid() = user_id);

-- ============================================================
-- 5) 상품 표 (사이트의 과일 16가지)
-- ============================================================
create table if not exists public.products (
  id          text primary key,              -- 사진 이름에서 딴 짧은 이름 (mango, apple ...)
  name        text    not null,              -- 상품 이름
  origin      text    not null,              -- 국산 / 수입
  is_best     boolean not null default false,-- 추천상품 표시 여부
  image       text    not null,              -- 사진 경로
  old_price   integer not null,              -- 정가
  price       integer not null,              -- 할인가
  sort_no     integer not null default 0,    -- 화면에 보일 순서
  on_sale     boolean not null default true, -- 판매 중인지
  updated_at  timestamptz not null default now()
);

-- 6) 상품은 누구나 볼 수 있게, 고치는 것은 막습니다
--    (가격 수정은 Supabase 대시보드 > Table Editor 에서 하세요)
alter table public.products enable row level security;
drop policy if exists products_read_all on public.products;
create policy products_read_all
  on public.products
  for select
  to anon, authenticated
  using (true);

-- ============================================================
-- 7) 회원 장바구니 표 (기기가 달라도 따라오게)
-- ============================================================
create table if not exists public.carts (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  items      jsonb not null default '[]'::jsonb,  -- 담은 품목 [{name, price, count}, ...]
  updated_at timestamptz not null default now()
);

-- 8) 자기 장바구니만 보고 고칠 수 있게 합니다
alter table public.carts enable row level security;

drop policy if exists carts_own_select on public.carts;
create policy carts_own_select on public.carts
  for select to authenticated using (auth.uid() = user_id);

drop policy if exists carts_own_insert on public.carts;
create policy carts_own_insert on public.carts
  for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists carts_own_update on public.carts;
create policy carts_own_update on public.carts
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists carts_own_delete on public.carts;
create policy carts_own_delete on public.carts
  for delete to authenticated using (auth.uid() = user_id);

-- ============================================================
-- 9) 찜한 상품 표
-- ============================================================
create table if not exists public.wishes (
  user_id    uuid not null references auth.users (id) on delete cascade,
  product_id text not null references public.products (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, product_id)
);

-- 10) 자기 찜만 보고 고칠 수 있게 합니다
alter table public.wishes enable row level security;

drop policy if exists wishes_own_select on public.wishes;
create policy wishes_own_select on public.wishes
  for select to authenticated using (auth.uid() = user_id);

drop policy if exists wishes_own_insert on public.wishes;
create policy wishes_own_insert on public.wishes
  for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists wishes_own_delete on public.wishes;
create policy wishes_own_delete on public.wishes
  for delete to authenticated using (auth.uid() = user_id);
