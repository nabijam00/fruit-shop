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
