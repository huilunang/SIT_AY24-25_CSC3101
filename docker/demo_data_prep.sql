UPDATE t_user set points = 1000 where id = 2;

INSERT INTO t_image (id, image, created_at)
VALUES
  (10, 'image_data_1', '2024-12-03 08:00:01.354347');

INSERT INTO t_recycle_transaction (id, type, subtype, confidence, description, date, created_at, prediction_id, image_id, user_id)
VALUES
  (301, 'plastic', 'plastic-bottle', 0.915143, '+ 1 pts from recycling', '2024-12-23', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (302, 'plastic', 'plastic-bottle', 0.915143, '+ 1 pts from recycling', '2024-12-25', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (303, 'plastic', 'plastic-cap', 0.915143, '+ 1 pts from recycling', '2024-12-26', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (304, 'glass', 'glass-bottle', 0.915143, '+ 1 pts from recycling', '2024-12-26', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (305, 'cardboard', 'cardboard-box', 0.915143, '+ 1 pts from recycling', '2025-01-26', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (306, 'cardboard', 'cardboard-box', 0.915143, '+ 1 pts from recycling', '2025-01-26', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (307, 'metal', 'metal-can', 0.915143, '+ 1 pts from recycling', '2025-01-27', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (308, 'non-recyclable', 'trash', 0.915143, '+ 1 pts from recycling', '2025-02-26', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (309, 'cardboard', 'cardboard-box', 0.915143, '+ 1 pts from recycling', '2025-02-26', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (310, 'metal', 'metal-can', 0.915143, '+ 1 pts from recycling', '2025-02-27', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (311, 'metal', 'metal-can', 0.915143, '+ 1 pts from recycling', '2025-03-21', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2),
  (312, 'non-recyclable', 'water', 0.915143, '+ 1 pts from recycling', '2025-03-21', '2025-03-23 08:00:47.185584', '0195c204-c451-745b-b0af-dd87886133cb', 10, 2);