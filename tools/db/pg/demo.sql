-- 1. 如果表已存在则删除，确保脚本可重复运行
DROP TABLE IF EXISTS demos;

-- 2. 创建超级简单的 demos 表
CREATE TABLE demos (
    id SERIAL PRIMARY KEY,           -- 自增 ID
    name VARCHAR(50) NOT NULL,      -- 姓名
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- 默认当前时间
);

-- 3. 填充基础测试数据
INSERT INTO demos (name)
VALUES 
('alice'),
('bob'),
('dvd'),
('ryn'),  -- 你的常用名
('guest');

-- 4. 立即查看结果
-- SELECT * FROM demos ORDER BY id;