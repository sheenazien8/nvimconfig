<?php
require __DIR__ . '/vendor/autoload.php';

use PHP_Parallel_Lint\PhpConsoleColor\ConsoleColor;
use PHP_Parallel_Lint\PhpConsoleHighlighter\Highlighter;

$highlighter = new Highlighter(new ConsoleColor());
$content = file_get_contents($argv[1]);

// prepend "<?php\n" so it parses as full PHP
echo $highlighter->getWholeFile("<?php\n" . $content);

