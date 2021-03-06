import IWaudSound;
import js.Browser;
import pixi.core.Pixi;
import pixi.core.text.Text;
import pixi.core.display.Container;
import pixi.plugins.app.Application;

class Base64 extends Application {

	var _btnContainer:Container;

	var _snd:WaudBase64Pack;
	var _base64sounds:Text;
	var _progress:Text;
	var _beep:IWaudSound;
	var _bell:IWaudSound;
	var _glass:IWaudSound;
	var _canopening:IWaudSound;
	var _countdown:IWaudSound;
	var _funk100:IWaudSound;

	var _globalRateLabel:Text;
	var _countdownRateLabel:Text;

	public function new() {
		super();
		Pixi.RESOLUTION = pixelRatio = Browser.window.devicePixelRatio;
		autoResize = true;
		backgroundColor = 0x5F04B4;
		roundPixels = true;
		onResize = _resize;
		super.start();

		_btnContainer = new Container();
		stage.addChild(_btnContainer);

		_base64sounds = new Text("Base64 Sounds: ", { font: "20px Tahoma", fill:"#FFFFFF" });
		_btnContainer.addChild(_base64sounds);
		_addButton("Beep", 0, 40, 80, 30, function() { _beep.play(); });
		_addButton("Bell", 80, 40, 80, 30, function() { _bell.play(); });
		_addButton("Glass", 160, 40, 80, 30, function() { _glass.play(); });
		_addButton("Can", 240, 40, 80, 30, function() { _canopening.play(); });
		_addButton("Countdown", 320, 40, 80, 30, function() { _countdown.play(); });
		_addButton("Funk", 400, 40, 80, 30, function() { _funk100.play(); });

		_globalRateLabel = new Text("Global Playback Rate: ", { font: "20px Tahoma", fill:"#FFFFFF" });
		_btnContainer.addChild(_globalRateLabel);
		_globalRateLabel.position.y = 90;
		_addButton("0.25", 0, 130, 80, 30, function() { setGlobalRate(0.25); });
		_addButton("0.5", 80, 130, 80, 30, function() { setGlobalRate(0.5); });
		_addButton("1", 160, 130, 80, 30, function() { setGlobalRate(1); });
		_addButton("1.5", 240, 130, 80, 30, function() { setGlobalRate(1.5); });
		_addButton("2", 320, 130, 80, 30, function() { setGlobalRate(2); });
		_addButton("4", 400, 130, 80, 30, function() { setGlobalRate(4); });

		_countdownRateLabel = new Text("Countdown Playback Rate: ", { font: "20px Tahoma", fill:"#FFFFFF" });
		_btnContainer.addChild(_countdownRateLabel);
		_countdownRateLabel.position.y = 180;
		_addButton("0.25", 0, 220, 80, 30, function() { setSoundRate(_countdown, 0.25); });
		_addButton("0.5", 80, 220, 80, 30, function() { setSoundRate(_countdown, 0.5); });
		_addButton("1", 160, 220, 80, 30, function() { setSoundRate(_countdown, 1); });
		_addButton("1.5", 240, 220, 80, 30, function() { setSoundRate(_countdown, 1.5); });
		_addButton("2", 320, 220, 80, 30, function() { setSoundRate(_countdown, 2); });
		_addButton("4", 400, 220, 80, 30, function() { setSoundRate(_countdown, 4); });

		_progress = new Text("", { font: "20px Tahoma", fill:"#FFFFFF" });
		stage.addChild(_progress);

		Waud.init();
		Waud.autoMute();
		Waud.enableTouchUnlock(touchUnlock);
		_snd = new WaudBase64Pack("assets/sounds.json", _onLoad, _onProgress);

		_resize();
	}

	function _onProgress(val:Float) {
		_progress.text = "Progress: " + Math.floor(val * 100) + "%";
	}

	function _onLoad(snds:Map<String, IWaudSound>) {
		trace("ALL LOADED");
		_beep = snds["test/beep.mp3"];
		_bell = snds["test/bell.mp3"];
		_glass = snds["test/glass.mp3"];
		_canopening = snds["test/canopening.mp3"];
		_countdown = snds["test/countdown.mp3"];
		_countdown.autoStop(false);
		_funk100 = snds["test/funk100.mp3"];
	}

	function touchUnlock() {

	}

	function _mute() {
		Waud.mute(true);
	}

	function _unmute() {
		Waud.mute(false);
	}

	function _stop() {
		Waud.stop();
	}

    function _pause() {
		Waud.pause();
	}

	function setGlobalRate(rate:Float) {
		Waud.playbackRate(rate);
		_globalRateLabel.text = "Global Playback Rate: " + Waud.playbackRate();
	}

	function setSoundRate(sound:IWaudSound, rate:Float) {
		sound.playbackRate(rate);
		_countdownRateLabel.text = "Countdown Playback Rate: " + sound.playbackRate();
	}

	function _addButton(label:String, x:Float, y:Float, width:Float, height:Float, callback:Dynamic) {
		var btn:Button = new Button(label, width, height);
		btn.position.set(x, y);
		btn.action.add(callback);
		btn.enable();
		_btnContainer.addChild(btn);
	}

	function _resize() {
		_btnContainer.position.set((Browser.window.innerWidth - _btnContainer.width) / 2, (Browser.window.innerHeight - _btnContainer.height) / 2);
	}

	static function main() {
		new Base64();
	}
}