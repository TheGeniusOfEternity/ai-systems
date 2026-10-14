"""End-to-end dialogue tests using the real SWI-Prolog process."""
import subprocess
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def run(text):
    result = subprocess.run(
        ['swipl', '-q', '-s', 'lab2/run.pl'], input=text,
        text=True, capture_output=True, cwd=ROOT, timeout=5,
    )
    assert result.returncode == 0, result.stderr
    assert not result.stderr, result.stderr
    return result.stdout


class DialogueTests(unittest.TestCase):
    def test_two_questions(self):
        text = run('item=шерсть\noverworld\nmob\nexit\n')
        self.assertIn('Какое измерение?', text)
        self.assertIn('Какой способ?', text)
        self.assertIn('mob sheep', text)
        self.assertIn('drops(sheep, white_wool)', text)

    def test_retry(self):
        text = run('item=carrot\nmoon\noverworld\nstructure\nexit\n')
        self.assertIn('Неизвестное значение', text)
        self.assertIn('structure village', text)

    def test_conflict(self):
        text = run('item=carrot;dimension=end;method=mob\nexit\n')
        self.assertIn('нет источников с выбранными условиями', text)
        self.assertIn('Альтернативы из БЗ', text)

    def test_recover_invalid_request(self):
        text = run('item=diamond\nitem=carrot;dimension=any;method=any\nexit\n')
        self.assertIn('Ошибка:', text)
        self.assertIn('structure village', text)

    def test_exit_with_spaces(self):
        text = run("  exit  \n")
        self.assertIn("Работа завершена.", text)
        self.assertNotIn("Ошибка:", text)

    def test_eof(self):
        self.assertNotIn('Запрос:', run('item=carrot\n'))


if __name__ == '__main__':
    unittest.main()
