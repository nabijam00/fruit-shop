-- 지하네 은하수 과일가게 - 상품 16가지
-- 2026-10-10 에 이미 넣어 두었습니다. 다시 넣어도 덮어쓰기만 됩니다.

insert into public.products (id, name, origin, is_best, image, old_price, price, sort_no) values
  ('mango', '프리미엄 애플망고', '수입', false, 'images/mango.jpg', 45000, 40500, 1),
('apple', '아침 햇살 꿀사과', '국산', true, 'images/apple.jpg', 32000, 28800, 2),
('melon', '고당도 머스크멜론', '국산', false, 'images/melon.jpg', 48000, 43200, 3),
('grape', '씨없는 샤인머스캣', '국산', true, 'images/grape.jpg', 52000, 46800, 4),
('strawberry', '프리미엄 설향 딸기', '국산', false, 'images/strawberry.jpg', 34000, 30600, 5),
('blueberry', '알알이 생블루베리', '수입', false, 'images/blueberry.jpg', 35000, 31500, 6),
('peach', '말랑 백도 복숭아', '국산', false, 'images/peach.jpg', 38000, 34200, 7),
('pear', '햇 신고배', '국산', false, 'images/pear.jpg', 42000, 37800, 8),
('cherry', '미국산 킹 체리', '수입', false, 'images/cherry.jpg', 46000, 41400, 9),
('persimmon', '아삭 단감', '국산', false, 'images/persimmon.jpg', 26000, 23400, 10),
('watermelon', '당도선별 수박', '국산', false, 'images/watermelon.jpg', 33000, 29700, 11),
('pineapple', '골드 파인애플', '수입', false, 'images/pineapple.jpg', 19000, 17100, 12),
('kiwi', '뉴질랜드 골드키위', '수입', false, 'images/kiwi.jpg', 31000, 27900, 13),
('plum', '새콤달콤 자두', '국산', false, 'images/plum.jpg', 28000, 25200, 14),
('fig', '생 무화과', '국산', false, 'images/fig.jpg', 39000, 35100, 15),
('mandarin', '제주 노지 감귤', '국산', false, 'images/mandarin.jpg', 24000, 21600, 16)
on conflict (id) do update set name = excluded.name, origin = excluded.origin, is_best = excluded.is_best, image = excluded.image, old_price = excluded.old_price, price = excluded.price, sort_no = excluded.sort_no;
