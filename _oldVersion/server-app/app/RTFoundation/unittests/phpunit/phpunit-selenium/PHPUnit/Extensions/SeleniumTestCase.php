<?php
/**
 * PHPUnit
 *
 * Copyright (c) 2010-2011, Sebastian Bergmann <sb@sebastian-bergmann.de>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Sebastian Bergmann nor the names of his
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * @package    PHPUnit_Selenium
 * @author     Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @copyright  2010-2011 Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @license    http://www.opensource.org/licenses/bsd-license.php  BSD License
 * @link       http://www.phpunit.de/
 * @since      File available since Release 1.0.0
 */

/**
 * TestCase class that uses Selenium to provide
 * the functionality required for web testing.
 *
 * @package    PHPUnit_Selenium
 * @author     Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @copyright  2010-2011 Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @license    http://www.opensource.org/licenses/bsd-license.php  BSD License
 * @version    Release: @package_version@
 * @link       http://www.phpunit.de/
 * @since      Class available since Release 1.0.0
 *
 * @method unknown  addLocationStrategy()
 * @method unknown  addLocationStrategyAndWait()
 * @method unknown  addScript()
 * @method unknown  addScriptAndWait()
 * @method unknown  addSelection()
 * @method unknown  addSelectionAndWait()
 * @method unknown  allowNativeXpath()
 * @method unknown  allowNativeXpathAndWait()
 * @method unknown  altKeyDown()
 * @method unknown  altKeyDownAndWait()
 * @method unknown  altKeyUp()
 * @method unknown  altKeyUpAndWait()
 * @method unknown  answerOnNextPrompt()
 * @method unknown  assignId()
 * @method unknown  assignIdAndWait()
 * @method unknown  attachFile()
 * @method unknown  break()
 * @method unknown  captureEntirePageScreenshot()
 * @method unknown  captureEntirePageScreenshotAndWait()
 * @method unknown  captureEntirePageScreenshotToStringAndWait()
 * @method unknown  captureScreenshotAndWait()
 * @method unknown  captureScreenshotToStringAndWait()
 * @method unknown  check()
 * @method unknown  checkAndWait()
 * @method unknown  chooseCancelOnNextConfirmation()
 * @method unknown  chooseCancelOnNextConfirmationAndWait()
 * @method unknown  chooseOkOnNextConfirmation()
 * @method unknown  chooseOkOnNextConfirmationAndWait()
 * @method unknown  click()
 * @method unknown  clickAndWait()
 * @method unknown  clickAt()
 * @method unknown  clickAtAndWait()
 * @method unknown  close()
 * @method unknown  contextMenu()
 * @method unknown  contextMenuAndWait()
 * @method unknown  contextMenuAt()
 * @method unknown  contextMenuAtAndWait()
 * @method unknown  controlKeyDown()
 * @method unknown  controlKeyDownAndWait()
 * @method unknown  controlKeyUp()
 * @method unknown  controlKeyUpAndWait()
 * @method unknown  createCookie()
 * @method unknown  createCookieAndWait()
 * @method unknown  deleteAllVisibleCookies()
 * @method unknown  deleteAllVisibleCookiesAndWait()
 * @method unknown  deleteCookie()
 * @method unknown  deleteCookieAndWait()
 * @method unknown  deselectPopUp()
 * @method unknown  deselectPopUpAndWait()
 * @method unknown  doubleClick()
 * @method unknown  doubleClickAndWait()
 * @method unknown  doubleClickAt()
 * @method unknown  doubleClickAtAndWait()
 * @method unknown  dragAndDrop()
 * @method unknown  dragAndDropAndWait()
 * @method unknown  dragAndDropToObject()
 * @method unknown  dragAndDropToObjectAndWait()
 * @method unknown  dragDrop()
 * @method unknown  dragDropAndWait()
 * @method unknown  echo()
 * @method unknown  fireEvent()
 * @method unknown  fireEventAndWait()
 * @method unknown  focus()
 * @method unknown  focusAndWait()
 * @method string   getAlert()
 * @method array    getAllButtons()
 * @method array    getAllFields()
 * @method array    getAllLinks()
 * @method array    getAllWindowIds()
 * @method array    getAllWindowNames()
 * @method array    getAllWindowTitles()
 * @method string   getAttribute()
 * @method array    getAttributeFromAllWindows()
 * @method string   getBodyText()
 * @method string   getConfirmation()
 * @method string   getCookie()
 * @method string   getCookieByName()
 * @method integer  getCursorPosition()
 * @method integer  getElementHeight()
 * @method integer  getElementIndex()
 * @method integer  getElementPositionLeft()
 * @method integer  getElementPositionTop()
 * @method integer  getElementWidth()
 * @method string   getEval()
 * @method string   getExpression()
 * @method string   getHtmlSource()
 * @method string   getLocation()
 * @method string   getLogMessages()
 * @method integer  getMouseSpeed()
 * @method string   getPrompt()
 * @method array    getSelectOptions()
 * @method string   getSelectedId()
 * @method array    getSelectedIds()
 * @method string   getSelectedIndex()
 * @method array    getSelectedIndexes()
 * @method string   getSelectedLabel()
 * @method array    getSelectedLabels()
 * @method string   getSelectedValue()
 * @method array    getSelectedValues()
 * @method unknown  getSpeed()
 * @method unknown  getSpeedAndWait()
 * @method string   getTable()
 * @method string   getText()
 * @method string   getTitle()
 * @method string   getValue()
 * @method boolean  getWhetherThisFrameMatchFrameExpression()
 * @method boolean  getWhetherThisWindowMatchWindowExpression()
 * @method integer  getXpathCount()
 * @method unknown  goBack()
 * @method unknown  goBackAndWait()
 * @method unknown  highlight()
 * @method unknown  highlightAndWait()
 * @method unknown  ignoreAttributesWithoutValue()
 * @method unknown  ignoreAttributesWithoutValueAndWait()
 * @method boolean  isAlertPresent()
 * @method boolean  isChecked()
 * @method boolean  isConfirmationPresent()
 * @method boolean  isCookiePresent()
 * @method boolean  isEditable()
 * @method boolean  isElementPresent()
 * @method boolean  isOrdered()
 * @method boolean  isPromptPresent()
 * @method boolean  isSomethingSelected()
 * @method boolean  isTextPresent()
 * @method boolean  isVisible()
 * @method unknown  keyDown()
 * @method unknown  keyDownAndWait()
 * @method unknown  keyDownNative()
 * @method unknown  keyDownNativeAndWait()
 * @method unknown  keyPress()
 * @method unknown  keyPressAndWait()
 * @method unknown  keyPressNative()
 * @method unknown  keyPressNativeAndWait()
 * @method unknown  keyUp()
 * @method unknown  keyUpAndWait()
 * @method unknown  keyUpNative()
 * @method unknown  keyUpNativeAndWait()
 * @method unknown  metaKeyDown()
 * @method unknown  metaKeyDownAndWait()
 * @method unknown  metaKeyUp()
 * @method unknown  metaKeyUpAndWait()
 * @method unknown  mouseDown()
 * @method unknown  mouseDownAndWait()
 * @method unknown  mouseDownAt()
 * @method unknown  mouseDownAtAndWait()
 * @method unknown  mouseMove()
 * @method unknown  mouseMoveAndWait()
 * @method unknown  mouseMoveAt()
 * @method unknown  mouseMoveAtAndWait()
 * @method unknown  mouseOut()
 * @method unknown  mouseOutAndWait()
 * @method unknown  mouseOver()
 * @method unknown  mouseOverAndWait()
 * @method unknown  mouseUp()
 * @method unknown  mouseUpAndWait()
 * @method unknown  mouseUpAt()
 * @method unknown  mouseUpAtAndWait()
 * @method unknown  mouseUpRight()
 * @method unknown  mouseUpRightAndWait()
 * @method unknown  mouseUpRightAt()
 * @method unknown  mouseUpRightAtAndWait()
 * @method unknown  open()
 * @method unknown  openWindow()
 * @method unknown  openWindowAndWait()
 * @method unknown  pause()
 * @method unknown  refresh()
 * @method unknown  refreshAndWait()
 * @method unknown  removeAllSelections()
 * @method unknown  removeAllSelectionsAndWait()
 * @method unknown  removeScript()
 * @method unknown  removeScriptAndWait()
 * @method unknown  removeSelection()
 * @method unknown  removeSelectionAndWait()
 * @method unknown  retrieveLastRemoteControlLogs()
 * @method unknown  rollup()
 * @method unknown  rollupAndWait()
 * @method unknown  runScript()
 * @method unknown  runScriptAndWait()
 * @method unknown  select()
 * @method unknown  selectAndWait()
 * @method unknown  selectFrame()
 * @method unknown  selectPopUp()
 * @method unknown  selectPopUpAndWait()
 * @method unknown  selectWindow()
 * @method unknown  setBrowserLogLevel()
 * @method unknown  setBrowserLogLevelAndWait()
 * @method unknown  setContext()
 * @method unknown  setCursorPosition()
 * @method unknown  setCursorPositionAndWait()
 * @method unknown  setMouseSpeed()
 * @method unknown  setMouseSpeedAndWait()
 * @method unknown  setSpeed()
 * @method unknown  setSpeedAndWait()
 * @method unknown  shiftKeyDown()
 * @method unknown  shiftKeyDownAndWait()
 * @method unknown  shiftKeyUp()
 * @method unknown  shiftKeyUpAndWait()
 * @method unknown  shutDownSeleniumServer()
 * @method unknown  store()
 * @method unknown  submit()
 * @method unknown  submitAndWait()
 * @method unknown  type()
 * @method unknown  typeAndWait()
 * @method unknown  typeKeys()
 * @method unknown  typeKeysAndWait()
 * @method unknown  uncheck()
 * @method unknown  uncheckAndWait()
 * @method unknown  useXpathLibrary()
 * @method unknown  useXpathLibraryAndWait()
 * @method unknown  waitForCondition()
 * @method unknown  waitForPageToLoad()
 * @method unknown  waitForPopUp()
 * @method unknown  windowFocus()
 * @method unknown  windowMaximize()
 */
abstract class PHPUnit_Extensions_SeleniumTestCase extends PHPUnit_Framework_TestCase
{
    /**
     * @var    array
     */
    public static $browsers = array();

    /**
     * @var    string
     */
    protected $browserName;

    /**
     * @var    boolean
     */
    protected $collectCodeCoverageInformation = FALSE;

    /**
     * @var    string
     */
    protected $coverageScriptUrl = '';

    /**
     * @var    PHPUnit_Extensions_SeleniumTestCase_Driver[]
     */
    protected $drivers = array();

    /**
     * @var    boolean
     */
    protected $inDefaultAssertions = FALSE;

    /**
     * @var    string
     */
    protected $testId;

    /**
     * @var    array
     * @access protected
     */
    protected $verificationErrors = array();

    /**
     * @var    boolean
     */
    protected $captureScreenshotOnFailure = FALSE;

    /**
     * @var    string
     */
    protected $screenshotPath = '';

    /**
     * @var    string
     */
    protected $screenshotUrl = '';

    /**
     * @var    integer  the number of seconds to wait before declaring
     *                  the Selenium server not reachable
     */
    protected $serverConnectionTimeOut = 10;

    /**
     * @var boolean
     */
    private $serverRunning;

    /**
     * @var boolean
     */
    private static $shareSession;

    /**
     * The last sessionId used for running a test.
     * @var string
     */
    private static $sessionId;

    /**
     * @param boolean
     */
    public static function shareSession($shareSession)
    {
        self::$shareSession = $shareSession;
    }

    /**
     * @param  string $name
     * @param  array  $data
     * @param  string $dataName
     * @param  array  $browser
     * @throws InvalidArgumentException
     */
    public function __construct($name = NULL, array $data = array(), $dataName = '', array $browser = array())
    {
        parent::__construct($name, $data, $dataName);
        $this->testId = md5(uniqid(rand(), TRUE));
        $this->getDriver($browser);
    }

    /**
     * @param  string $className
     * @return PHPUnit_Framework_TestSuite
     */
    public static function suite($className)
    {
        $suite = new PHPUnit_Framework_TestSuite;
        $suite->setName($className);

        $class            = new ReflectionClass($className);
        $classGroups      = PHPUnit_Util_Test::getGroups($className);
        $staticProperties = $class->getStaticProperties();

        // Create tests from Selenese/HTML files.
        if (isset($staticProperties['seleneseDirectory']) &&
            is_dir($staticProperties['seleneseDirectory'])) {
            $files = array_merge(
              self::getSeleneseFiles($staticProperties['seleneseDirectory'], '.htm'),
              self::getSeleneseFiles($staticProperties['seleneseDirectory'], '.html')
            );

            // Create tests from Selenese/HTML files for multiple browsers.
            if (!empty($staticProperties['browsers'])) {
                foreach ($staticProperties['browsers'] as $browser) {
                    $browserSuite = new PHPUnit_Framework_TestSuite;
                    $browserSuite->setName($className . ': ' . $browser['name']);

                    foreach ($files as $file) {
                        $browserSuite->addTest(
                          new $className($file, array(), '', $browser),
                          $classGroups
                        );
                    }

                    $suite->addTest($browserSuite);
                }
            }

            // Create tests from Selenese/HTML files for single browser.
            else {
                foreach ($files as $file) {
                    $suite->addTest(new $className($file), $classGroups);
                }
            }
        }

        // Create tests from test methods for multiple browsers.
        if (!empty($staticProperties['browsers'])) {
            foreach ($staticProperties['browsers'] as $browser) {
                $browserSuite = new PHPUnit_Framework_TestSuite;
                $browserSuite->setName($className . ': ' . $browser['name']);

                foreach ($class->getMethods() as $method) {
                    if (PHPUnit_Framework_TestSuite::isPublicTestMethod($method)) {
                        $name   = $method->getName();
                        $data   = PHPUnit_Util_Test::getProvidedData($className, $name);
                        $groups = PHPUnit_Util_Test::getGroups($className, $name);

                        // Test method with @dataProvider.
                        if (is_array($data) || $data instanceof Iterator) {
                            $dataSuite = new PHPUnit_Framework_TestSuite_DataProvider(
                              $className . '::' . $name
                            );

                            foreach ($data as $_dataName => $_data) {
                                $dataSuite->addTest(
                                  new $className($name, $_data, $_dataName, $browser),
                                  $groups
                                );
                            }

                            $browserSuite->addTest($dataSuite);
                        }

                        // Test method with invalid @dataProvider.
                        else if ($data === FALSE) {
                            $browserSuite->addTest(
                              new PHPUnit_Framework_Warning(
                                sprintf(
                                  'The data provider specified for %s::%s is invalid.',
                                  $className,
                                  $name
                                )
                              )
                            );
                        }

                        // Test method without @dataProvider.
                        else {
                            $browserSuite->addTest(
                              new $className($name, array(), '', $browser), $groups
                            );
                        }
                    }
                }

                $suite->addTest($browserSuite);
            }
        }

        // Create tests from test methods for single browser.
        else {
            foreach ($class->getMethods() as $method) {
                if (PHPUnit_Framework_TestSuite::isPublicTestMethod($method)) {
                    $name   = $method->getName();
                    $data   = PHPUnit_Util_Test::getProvidedData($className, $name);
                    $groups = PHPUnit_Util_Test::getGroups($className, $name);

                    // Test method with @dataProvider.
                    if (is_array($data) || $data instanceof Iterator) {
                        $dataSuite = new PHPUnit_Framework_TestSuite_DataProvider(
                          $className . '::' . $name
                        );

                        foreach ($data as $_dataName => $_data) {
                            $dataSuite->addTest(
                              new $className($name, $_data, $_dataName),
                              $groups
                            );
                        }

                        $suite->addTest($dataSuite);
                    }

                    // Test method with invalid @dataProvider.
                    else if ($data === FALSE) {
                        $suite->addTest(
                          new PHPUnit_Framework_Warning(
                            sprintf(
                              'The data provider specified for %s::%s is invalid.',
                              $className,
                              $name
                            )
                          )
                        );
                    }

                    // Test method without @dataProvider.
                    else {
                        $suite->addTest(
                          new $className($name), $groups
                        );
                    }
                }
            }
        }

        return $suite;
    }

    /**
     * Runs the test case and collects the results in a TestResult object.
     * If no TestResult object is passed a new one will be created.
     *
     * @param  PHPUnit_Framework_TestResult $result
     * @return PHPUnit_Framework_TestResult
     * @throws InvalidArgumentException
     */
    public function run(PHPUnit_Framework_TestResult $result = NULL)
    {
        if ($result === NULL) {
            $result = $this->createResult();
        }

        $this->setTestResultObject($result);

        $this->collectCodeCoverageInformation = $result->getCollectCodeCoverageInformation();

        foreach ($this->drivers as $driver) {
            $driver->setCollectCodeCoverageInformation(
              $this->collectCodeCoverageInformation
            );
        }

        if (!$this->handleDependencies()) {
            return;
        }

        $result->run($this);

        if ($this->collectCodeCoverageInformation) {
            $result->getCodeCoverage()->append(
              $this->getCodeCoverage(), $this
            );
        }

        return $result;
    }

    /**
     * @param  array $browser
     * @return PHPUnit_Extensions_SeleniumTestCase_Driver
     */
    protected function getDriver(array $browser)
    {
        if (isset($browser['name'])) {
            if (!is_string($browser['name'])) {
                throw new InvalidArgumentException(
                  'Array element "name" is no string.'
                );
            }
        } else {
            $browser['name'] = '';
        }

        if (isset($browser['browser'])) {
            if (!is_string($browser['browser'])) {
                throw new InvalidArgumentException(
                  'Array element "browser" is no string.'
                );
            }
        } else {
            $browser['browser'] = '';
        }

        if (isset($browser['host'])) {
            if (!is_string($browser['host'])) {
                throw new InvalidArgumentException(
                  'Array element "host" is no string.'
                );
            }
        } else {
            $browser['host'] = 'localhost';
        }

        if (isset($browser['port'])) {
            if (!is_int($browser['port'])) {
                throw new InvalidArgumentException(
                  'Array element "port" is no integer.'
                );
            }
        } else {
            $browser['port'] = 4444;
        }

        if (isset($browser['timeout'])) {
            if (!is_int($browser['timeout'])) {
                throw new InvalidArgumentException(
                  'Array element "timeout" is no integer.'
                );
            }
        } else {
            $browser['timeout'] = 30;
        }

        if (isset($browser['httpTimeout'])) {
            if (!is_int($browser['httpTimeout'])) {
                throw new InvalidArgumentException(
                  'Array element "httpTimeout" is no integer.'
                );
            }
        } else {
            $browser['httpTimeout'] = 45;
        }

        $driver = new PHPUnit_Extensions_SeleniumTestCase_Driver;
        $driver->setName($browser['name']);
        $driver->setBrowser($browser['browser']);
        $driver->setHost($browser['host']);
        $driver->setPort($browser['port']);
        $driver->setTimeout($browser['timeout']);
        $driver->setHttpTimeout($browser['httpTimeout']);
        $driver->setTestCase($this);
        $driver->setTestId($this->testId);

        $this->drivers[] = $driver;

        return $driver;
    }

    public function skipWithNoServerRunning()
    {
        $serverRunning = @fsockopen($this->drivers[0]->getHost(), $this->drivers[0]->getPort(), $errno, $errstr, $this->serverConnectionTimeOut);
        if (!$serverRunning) {
            $this->markTestSkipped(
              sprintf(
                'Could not connect to the Selenium Server on %s:%d.',
                $this->drivers[0]->getHost(),
                $this->drivers[0]->getPort()
              )
            );
        }
    }

    /**
     * @throws RuntimeException
     */
    protected function runTest()
    {
        $this->skipWithNoServerRunning();

        if (self::$shareSession && self::$sessionId !== NULL) {
            $this->setSessionId(self::$sessionId);
            $this->selectWindow('null');
        } else {
            self::$sessionId = $this->start();
        }

        if (!is_file($this->getName(FALSE))) {
            parent::runTest();
        } else {
            $this->runSelenese($this->getName(FALSE));
        }

        if (!empty($this->verificationErrors)) {
            $this->fail(implode("\n", $this->verificationErrors));
        }

        if (!self::$shareSession) {
            $this->stopSession();
        }
    }

    private function stopSession()
    {
        try {
            $this->stop();
        } catch (RuntimeException $e) { }
    }

    /**
     * Returns a string representation of the test case.
     *
     * @return string
     */
    public function toString()
    {
        $buffer = parent::toString();

        if (!empty($this->browserName)) {
            $buffer .= ' with browser ' . $this->browserName;
        }

        return $buffer;
    }

    /**
     * Runs a test from a Selenese (HTML) specification.
     *
     * @param string $filename
     */
    public function runSelenese($filename)
    {
        $document = PHPUnit_Util_XML::loadFile($filename, TRUE);
        $xpath    = new DOMXPath($document);
        $rows     = $xpath->query('body/table/tbody/tr');

        foreach ($rows as $row) {
            $action    = NULL;
            $arguments = array();
            $columns   = $xpath->query('td', $row);

            foreach ($columns as $column) {
                if ($action === NULL) {
                    $action = PHPUnit_Util_XML::nodeToText($column);
                } else {
                    $arguments[] = PHPUnit_Util_XML::nodeToText($column);
                }
            }

            if (method_exists($this, $action)) {
                call_user_func_array(array($this, $action), $arguments);
            } else {
                $this->__call($action, $arguments);
            }
        }
    }

    /**
     * Delegate method calls to the driver.
     *
     * @param  string $command
     * @param  array  $arguments
     * @return mixed
     */
    public function __call($command, $arguments)
    {
        $result = call_user_func_array(
          array($this->drivers[0], $command), $arguments
        );

        $this->verificationErrors = array_merge(
          $this->verificationErrors, $this->drivers[0]->getVerificationErrors()
        );

        $this->drivers[0]->clearVerificationErrors();

        return $result;
    }

    /**
     * Asserts that an element's value is equal to a given string.
     *
     * @param  string $locator
     * @param  string $text
     * @param  string $message
     */
    public function assertElementValueEquals($locator, $text, $message = '')
    {
        $this->assertEquals($text, $this->getValue($locator), $message);
    }

    /**
     * Asserts that an element's value is not equal to a given string.
     *
     * @param  string $locator
     * @param  string $text
     * @param  string $message
     */
    public function assertElementValueNotEquals($locator, $text, $message = '')
    {
        $this->assertNotEquals($text, $this->getValue($locator), $message);
    }

    /**
     * Asserts that an element's value contains a given string.
     *
     * @param  string $locator
     * @param  string $text
     * @param  string $message
     */
    public function assertElementValueContains($locator, $text, $message = '')
    {
        $this->assertContains($text, $this->getValue($locator), $message);
    }

    /**
     * Asserts that an element's value does not contain a given string.
     *
     * @param  string $locator
     * @param  string $text
     * @param  string $message
     */
    public function assertElementValueNotContains($locator, $text, $message = '')
    {
        $this->assertNotContains($text, $this->getValue($locator), $message);
    }

    /**
     * Asserts that an element contains a given string.
     *
     * @param  string $locator
     * @param  string $text
     * @param  string $message
     */
    public function assertElementContainsText($locator, $text, $message = '')
    {
        $this->assertContains($text, $this->getText($locator), $message);
    }

    /**
     * Asserts that an element does not contain a given string.
     *
     * @param  string $locator
     * @param  string $text
     * @param  string $message
     */
    public function assertElementNotContainsText($locator, $text, $message = '')
    {
        $this->assertNotContains($text, $this->getText($locator), $message);
    }

    /**
     * Asserts that a select element has a specific option.
     *
     * @param  string $selectLocator
     * @param  string $option
     * @param  string $message
     */
    public function assertSelectHasOption($selectLocator, $option, $message = '')
    {
        $this->assertContains($option, $this->getSelectOptions($selectLocator), $message);
    }

    /**
     * Asserts that a select element does not have a specific option.
     *
     * @param  string $selectLocator
     * @param  string $option
     * @param  string $message
     */
    public function assertSelectNotHasOption($selectLocator, $option, $message = '')
    {
        $this->assertNotContains($option, $this->getSelectOptions($selectLocator), $message);
    }

    /**
     * Asserts that a specific label is selected.
     *
     * @param  string $selectLocator
     * @param  string $value
     * @param  string $message
     */
    public function assertSelected($selectLocator, $option, $message = '')
    {
        if ($message == '') {
            $message = sprintf(
              'Label "%s" not selected in "%s".',
              $option,
              $selectLocator
            );
        }

        $this->assertEquals(
          $option,
          $this->getSelectedLabel($selectLocator),
          $message
        );
    }

    /**
     * Asserts that a specific label is not selected.
     *
     * @param  string $selectLocator
     * @param  string $value
     * @param  string $message
     */
    public function assertNotSelected($selectLocator, $option, $message = '')
    {
        if ($message == '') {
            $message = sprintf(
              'Label "%s" selected in "%s".',
              $option,
              $selectLocator
            );
        }

        $this->assertNotEquals(
          $option,
          $this->getSelectedLabel($selectLocator),
          $message
        );
    }

    /**
     * Asserts that a specific value is selected.
     *
     * @param  string $selectLocator
     * @param  string $value
     * @param  string $message
     */
    public function assertIsSelected($selectLocator, $value, $message = '')
    {
        if ($message == '') {
            $message = sprintf(
              'Value "%s" not selected in "%s".',
              $value,
              $selectLocator
            );
        }

        $this->assertEquals(
          $value, $this->getSelectedValue($selectLocator),
          $message
        );
    }

    /**
     * Asserts that a specific value is not selected.
     *
     * @param  string $selectLocator
     * @param  string $value
     * @param  string $message
     */
    public function assertIsNotSelected($selectLocator, $value, $message = '')
    {
        if ($message == '') {
            $message = sprintf(
              'Value "%s" selected in "%s".',
              $value,
              $selectLocator
            );
        }

        $this->assertNotEquals(
          $value,
          $this->getSelectedValue($selectLocator),
          $message
        );
    }

    /**
     * Template Method that is called after Selenium actions.
     *
     * @param  string $action
     */
    protected function defaultAssertions($action)
    {
    }

    /**
     * @return array
     */
    protected function getCodeCoverage()
    {
        if (!empty($this->coverageScriptUrl)) {
            $url = sprintf(
              '%s?PHPUNIT_SELENIUM_TEST_ID=%s',
              $this->coverageScriptUrl,
              $this->testId
            );

            $buffer = @file_get_contents($url);

            if ($buffer !== FALSE) {
                $coverageData = unserialize($buffer);
                if (is_array($coverageData)) {
                    return $this->matchLocalAndRemotePaths($coverageData);
                } else {
                    throw new Exception('Empty or invalid code coverage data received from url "' . $url . '"');
                }
            }
        }

        return array();
    }

    /**
     * @param  array $coverage
     * @return array
     * @author Mattis Stordalen Flister <mattis@xait.no>
     */
    protected function matchLocalAndRemotePaths(array $coverage)
    {
        $coverageWithLocalPaths = array();

        foreach ($coverage as $originalRemotePath => $data) {
            $remotePath = $originalRemotePath;
            $separator  = $this->findDirectorySeparator($remotePath);

            while (!($localpath = PHPUnit_Util_Filesystem::fileExistsInIncludePath($remotePath)) &&
                   strpos($remotePath, $separator) !== FALSE) {
                $remotePath = substr($remotePath, strpos($remotePath, $separator) + 1);
            }

            if ($localpath && md5_file($localpath) == $data['md5']) {
                $coverageWithLocalPaths[$localpath] = $data['coverage'];
            }
        }

        return $coverageWithLocalPaths;
    }

    /**
     * @param  string $path
     * @return string
     * @author Mattis Stordalen Flister <mattis@xait.no>
     */
    protected function findDirectorySeparator($path)
    {
        if (strpos($path, '/') !== FALSE) {
            return '/';
        }

        return '\\';
    }

    /**
     * @param  string $path
     * @return array
     * @author Mattis Stordalen Flister <mattis@xait.no>
     */
    protected function explodeDirectories($path)
    {
        return explode($this->findDirectorySeparator($path), dirname($path));
    }

    /**
     * @param  string $directory
     * @param  string $suffix
     * @return array
     */
    protected static function getSeleneseFiles($directory, $suffix)
    {
        $facade = new File_Iterator_Facade;

        return $facade->getFilesAsArray($directory, $suffix);
    }

    /**
     * @param  string $action
     */
    public function runDefaultAssertions($action)
    {
        if (!$this->inDefaultAssertions) {
            $this->inDefaultAssertions = TRUE;
            $this->defaultAssertions($action);
            $this->inDefaultAssertions = FALSE;
        }
    }

    /**
     * This method is called when a test method did not execute successfully.
     *
     * @param Exception $e
     */
    protected function onNotSuccessfulTest(Exception $e)
    {
        if ($e instanceof PHPUnit_Framework_ExpectationFailedException) {
            $buffer  = 'Current URL: ' . $this->drivers[0]->getLocation() .
                       "\n";

            if ($this->captureScreenshotOnFailure &&
                !empty($this->screenshotPath) &&
                !empty($this->screenshotUrl)) {
                $filename = $this->getScreenshotPath() . $this->testId . '.png';

                $this->drivers[0]->captureEntirePageScreenshot($filename);

                $buffer .= 'Screenshot: ' . $this->screenshotUrl . '/' .
                           $this->testId . ".png\n";
            }
        }

        $this->stopSession();
        self::$sessionId = NULL;

        if ($e instanceof PHPUnit_Framework_ExpectationFailedException) {
            if (is_object($e->getComparisonFailure())) {
                $message = $e->getComparisonFailure()->toString();
            } else {
                $message = $e->getMessage();
            }

            $buffer .= "\n" . $message;

            throw new PHPUnit_Framework_ExpectationFailedException($buffer);
        }

        throw $e;
    }

    /**
     * Returns correct path to screenshot save path.
     *
     * @return string
     */
    protected function getScreenshotPath()
    {
        $path = $this->screenshotPath;

        if (!in_array(substr($path, strlen($path) -1, 1), array("/","\\"))) {
            $path .= DIRECTORY_SEPARATOR;
        }

        return $path;
    }
}
