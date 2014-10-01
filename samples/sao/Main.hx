import hxd.Math;

class CustomRenderer extends h3d.scene.Renderer {

	var sao : h3d.pass.ScalableAO;
	var out : h3d.mat.Texture;

	public function new() {
		super();
		sao = new h3d.pass.ScalableAO();
	}

	override function process( ctx, passes ) {
		super.process(ctx, passes);
		sao.apply(depth.getTexture(), normal.getTexture(), ctx.camera);
	}

}

class Main extends hxd.App {

	var time : Float = 0.;

	function initMaterial( m : h3d.mat.MeshMaterial ) {
		m.mainPass.enableLights = true;
		m.addPass(new h3d.mat.Pass("depth", m.mainPass));
		m.addPass(new h3d.mat.Pass("normal", m.mainPass));
	}

	override function init() {

		var floor = new h3d.prim.Cube(10, 10, 0.1);
		floor.unindex();
		floor.addNormals();
		floor.translate( -5, -5, 0);
		var m = new h3d.scene.Mesh(floor, s3d);
		initMaterial(m.material);

		for( i in 0...100 ) {
			var box : h3d.prim.Polygon = Std.random(2) == 0 ? new h3d.prim.Sphere(16,12) : new h3d.prim.Cube(Math.random(),Math.random(), 2);
			box.unindex();
			box.addNormals();
			var p = new h3d.scene.Mesh(box, s3d);
			p.x = Math.srand(3);
			p.y = Math.srand(3);
			p.z = -Math.random() * 1.8;
			initMaterial(p.material);
		}
		s3d.camera.zNear = 0.5;
		s3d.camera.zFar = 15;

		s3d.lightSystem.ambientLight.set(0.5, 0.5, 0.5);
		var dir = new h3d.scene.DirLight(new h3d.Vector( -0.3, -0.2, -1), s3d);

		s3d.renderer = new CustomRenderer();
	}

	override function update( dt : Float ) {
		time += dt * 0.001;
		s3d.camera.pos.set(6 * Math.cos(time), 6 * Math.sin(time), 3);
	}

	public static var inst : Main;
	static function main() {
		inst = new Main();
	}

}